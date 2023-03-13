class_name Cheatsheet extends Control

@export var toggle_shortcut: Shortcut
@export var close_shortcut: Shortcut

@onready var quake_console: Control = %QuakeConsole
@onready var console_text: RichTextLabel = %ConsoleText
@onready var command_input: LineEdit = %CommandInput
@onready var run_button: Button = %RunButton

var history: Array[String] = []
var db := CommandDB.new()

func _ready() -> void:
	quake_console.hide()
	quake_console.position.y = -quake_console.size.y
	
	db.register('clear', clear)
	db.register('ping', func(): println('pong'))
	db.register('echo', func(str: String): println(str))

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
	console_text.append_text(bbcode)
	console_text.add_text('\n')

func putln(text: String) -> void:
	console_text.add_text(text)
	console_text.add_text('\n')

func clear() -> void:
	console_text.clear()

func run() -> void:
	var str := command_input.text
	if str.length() == 0: return
	command_input.clear()
	putln(str)
	
	db.run(str)

func _on_run_button_pressed() -> void:
	run()
func _on_command_input_text_submitted(new_text: String) -> void:
	run()
