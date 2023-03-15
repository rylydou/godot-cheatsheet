extends CanvasLayer

const Command := preload('res://addons/cheatsheet/scripts/command.gd')
const CommandDB := preload('res://addons/cheatsheet/scripts/command_db.gd')
const CoreCommands := preload('res://addons/cheatsheet/scripts/core_commands.gd')

@export var toggle_shortcut: Shortcut
@export var close_shortcut: Shortcut

@onready var menu: Control = %Menu
@onready var console: RichTextLabel = %ConsoleText
@onready var command_input: LineEdit = %CommandInput
@onready var run_button: Button = %RunButton

var history: Array[String] = []
var db := CommandDB.new()

func _ready() -> void:
	menu.hide()
	menu.position.y = -menu.size.y
	
	CoreCommands.new().register()

func _shortcut_input(event: InputEvent) -> void:
	if close_shortcut.matches_event(event) and event.is_pressed():
		get_viewport().set_input_as_handled()
		close()
	
	if toggle_shortcut.matches_event(event) and event.is_pressed():
		get_viewport().set_input_as_handled()
		if is_cheatsheet_open:
			close()
		else:
			command_input.clear()
			open()

var is_cheatsheet_open := false
var slide_tween: Tween
func open() -> void:
	if is_cheatsheet_open: return
	is_cheatsheet_open = true
	
	menu.show()
	command_input.grab_focus()
	
	if slide_tween:
		slide_tween.kill()
	slide_tween = create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	slide_tween.set_trans(Tween.TRANS_QUART)
	slide_tween.tween_property(menu, 'position:y', 0, .4)

func close() -> void:
	if not is_cheatsheet_open: return
	is_cheatsheet_open = false
	
	command_input.release_focus()
	
	if slide_tween:
		slide_tween.kill()
	slide_tween = create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	slide_tween.set_trans(Tween.TRANS_QUART)
	slide_tween.tween_property(menu, 'position:y', -menu.size.y, .4)
	slide_tween.tween_callback(menu.hide)

func register(name: String, callback: Callable) -> Command:
	return db.register(name, callback)

func printlb(text:String) -> void:
	console.append_text('[color=ff8ccc]%10s:[/color] ' % text)

func println(bbcode: String) -> void:
	console.append_text(bbcode)
	console.add_text('\n')

func putln(text: String) -> void:
	console.add_text(text)
	console.add_text('\n')

func run() -> void:
	var str := command_input.text
	if str.length() == 0: return
	command_input.clear()
	
	console.append_text('\n[color=42ffc2]$[/color] ')
	console.add_text(str)
	console.add_text('\n')
	db.run(str)
	
	history.append(str)

func _on_run_button_pressed() -> void:
	run()

func _on_command_input_text_submitted(new_text: String) -> void:
	run()

func _on_command_input_text_changed(new_text: String) -> void:
	if new_text == '`':
		command_input.clear()
		close()
	var is_empty := new_text.length() == 0
	run_button.disabled = is_empty

func _on_console_text_meta_clicked(meta) -> void:
	OS.shell_open(meta)
