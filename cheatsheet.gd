class_name Cheatsheet extends Control

@export var toggle_shortcut: Shortcut
@export var close_shortcut: Shortcut

@onready var quake_console: Control = %QuakeConsole
@onready var console: RichTextLabel = %ConsoleText
@onready var command_input: LineEdit = %CommandInput
@onready var run_button: Button = %RunButton

var history: Array[String] = []
var db := CommandDB.new()

func _ready() -> void:
	quake_console.hide()
	quake_console.position.y = -quake_console.size.y
	
	console.clear()
	println("Cheatsheet: Console")
	println("Type '[color=abc9ff]help[/color]' to list available commands")
	
	db.unknown_command.connect(
		func(name):
			println("[color=ff7085]unknown command '%s'[/color]" % name)
	)
	
	db.register('help', help)
	db.register('clear', clear)
	db.register('echo', func(str: String): println(str))
	db.register('quit', get_tree().quit)
	db.register('reload', get_tree().reload_current_scene)

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
	
	quake_console.show()
	command_input.grab_focus()
	
	if slide_tween:
		slide_tween.kill()
	slide_tween = quake_console.create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	slide_tween.set_trans(Tween.TRANS_QUART)
	slide_tween.tween_property(quake_console, 'position:y', 0, 0.2).from(-quake_console.size.y)

func close() -> void:
	if not is_cheatsheet_open: return
	is_cheatsheet_open = false
	
	command_input.release_focus()
	
	if slide_tween:
		slide_tween.kill()
	slide_tween = quake_console.create_tween()
	slide_tween.set_ease(Tween.EASE_IN)
	slide_tween.set_trans(Tween.TRANS_QUART)
	slide_tween.tween_property(quake_console, 'position:y', -quake_console.size.y, 0.3)
	slide_tween.tween_callback(quake_console.hide)

func println(bbcode: String) -> void:
	console.append_text(bbcode)
	console.add_text('\n')

func putln(text: String) -> void:
	console.add_text(text)
	console.add_text('\n')

func help() -> void:
	var index := 1
	for name in db.commands:
		println(str(index) + '. ' + name)
		index += 1

func clear() -> void:
	console.clear()

func run() -> void:
	var str := command_input.text
	if str.length() == 0: return
	command_input.clear()
	
	console.append_text('[color=42ffc2]$[/color] ')
	console.add_text(str)
	console.add_text('\n')
	db.run(str)

func _on_run_button_pressed() -> void:
	run()
func _on_command_input_text_submitted(new_text: String) -> void:
	run()


func _on_command_input_text_changed(new_text: String) -> void:
	run_button.disabled = new_text.length() == 0
