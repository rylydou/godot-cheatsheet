@icon('res://addons/cheatsheet/icons/console.svg')
extends CanvasLayer

const Command := preload('res://addons/cheatsheet/scripts/command.gd')
const CommandDB := preload('res://addons/cheatsheet/scripts/command_db.gd')
const CoreCommands := preload('res://addons/cheatsheet/scripts/core_commands.gd')

signal commands_changed()

@export var toggle_shortcut: Shortcut
@export var close_shortcut: Shortcut

@onready var menu: Control = %Menu
@onready var console: RichTextLabel = %ConsoleText
@onready var command_input: LineEdit = %CommandInput
@onready var console_key_prompt: Control = %ConsoleKeyPrompt
@onready var stats_display: Control = %StatsDisplay

var history: Array[String] = []
var history_index := -1
var db := CommandDB.new()

func _ready() -> void:
	menu.hide()
	menu.position.y = -menu.size.y
	stats_display.hide()
	
	CoreCommands.new().register()
	
	console_key_prompt.position.y = -console_key_prompt.size.y
	console_key_prompt.show()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(console_key_prompt, 'position:y', 0., .1).set_delay(1.)
	tween.tween_property(console_key_prompt, 'position:y', -console_key_prompt.size.y, .1).set_delay(3.)
	tween.tween_callback(console_key_prompt.hide)

func _shortcut_input(event: InputEvent) -> void:
	if close_shortcut.matches_event(event) and event.is_pressed():
		close()
		get_viewport().set_input_as_handled()
		return
	
	if toggle_shortcut.matches_event(event) and event.is_pressed():
		if is_cheatsheet_open:
			close()
		else:
			command_input.clear()
			open()
		get_viewport().set_input_as_handled()
		return

var is_cheatsheet_open := false
var slide_tween: Tween
func open() -> void:
	if is_cheatsheet_open: return
	is_cheatsheet_open = true
	
	console_key_prompt.hide()
	menu.show()
	command_input.grab_focus()
	
	if slide_tween:
		slide_tween.kill()
	slide_tween = create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	slide_tween.set_trans(Tween.TRANS_QUART)
	slide_tween.tween_property(menu, 'position:y', 0, .3).from_current()

func close() -> void:
	if not is_cheatsheet_open: return
	is_cheatsheet_open = false
	
	command_input.release_focus()
	
	if slide_tween:
		slide_tween.kill()
	slide_tween = create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	slide_tween.set_trans(Tween.TRANS_QUART)
	slide_tween.tween_property(menu, 'position:y', -menu.size.y, .4).from_current()
	slide_tween.tween_callback(menu.hide)

func register(name: String, callback: Callable) -> Command:
	var command := db.register(name, callback)
	commands_changed.emit()
	return command

func println(bbcode: String) -> void:
	console.append_text(bbcode)
	console.add_text('\n')

func print(bbcode: String) -> void:
	console.append_text(bbcode)

func printlb(text:String) -> void:
	console.append_text('[color=ff8ccc]%12s:[/color] ' % text)

func error(bbcode:String) -> void:
	console.append_text('[color=ff7085]%s[/color]' % bbcode)

func run() -> void:
	var str := command_input.text
	if str.length() == 0: return
	command_input.clear()
	
	console.append_text('\n[color=42ffc2]$[/color] ')
	console.add_text(str)
	console.add_text('\n')
	db.run(str)
	
	history.push_front(str)
	if history.size() > 20:
		history.pop_back()
	history_index = -1

func toogle_stats():
	stats_display.visible = not stats_display.visible

func _on_command_input_text_submitted(new_text: String) -> void:
	run()

func _on_command_input_text_changed(new_text: String) -> void:
	if new_text == '`':
		command_input.clear()
		close()
	history_index = -1

func _on_console_text_meta_clicked(meta) -> void:
	OS.shell_open(meta)

func _on_command_input_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_up'):
		if history_index < history.size() - 1:
			history_index += 1
			update_history()
		command_input.grab_focus()
		get_viewport().set_input_as_handled()
		return
	
	if event.is_action_pressed('ui_down'):
		if history_index >= 0:
			history_index -= 1
			update_history()
		command_input.grab_focus()
		get_viewport().set_input_as_handled()
		return

func update_history() -> void:
	if history_index >= 0:
		command_input.text = history[history_index]
		command_input.caret_column = command_input.text.length()
		return
	
	command_input.text = ''
