extends CanvasLayer

const CommandDB := preload('res://addons/cheatsheet/scripts/command_db.gd')

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
	
	db.unknown_command.connect(
		func(name):
			println("[color=ff7085]unknown command '%s'[/color]" % name)
	)

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
	slide_tween.tween_property(menu, 'position:y', 0, 0.2).from(-menu.size.y)

func close() -> void:
	if not is_cheatsheet_open: return
	is_cheatsheet_open = false
	
	command_input.release_focus()
	
	if slide_tween:
		slide_tween.kill()
	slide_tween = create_tween()
	slide_tween.set_ease(Tween.EASE_IN)
	slide_tween.set_trans(Tween.TRANS_SINE)
	slide_tween.tween_property(menu, 'position:y', -menu.size.y, 0.2)
	slide_tween.tween_callback(menu.hide)

func printlb(text:String) -> void:
	console.append_text('[color=ff8ccc]%s:[/color]\t' % text)

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
	
	console.append_text('[color=42ffc2]$[/color] ')
	console.add_text(str)
	console.add_text('\n')
	db.run(str)
	
	history.append(str)

func _on_run_button_pressed() -> void:
	run()

func _on_command_input_text_submitted(new_text: String) -> void:
	run()

func _on_command_input_text_changed(new_text: String) -> void:
	var is_empty := new_text.length() == 0
	run_button.disabled = is_empty

func _on_console_text_meta_clicked(meta) -> void:
	OS.shell_open(meta)
