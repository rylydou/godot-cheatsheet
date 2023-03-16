class_name CsCommand extends RefCounted

const Argument := preload('res://addons/cheatsheet/scripts/argument.gd')

var name: String
var callback: Callable
func _init(name: String, callback: Callable) -> void:
	self.name = name
	self.callback = callback

var infos: String
func info(text: String) -> CsCommand:
	infos = text
	return self

var args: Array[Argument]
func arg(name: String, type: Variant.Type) -> CsCommand:
	var a := Argument.new(name, type)
	args.append(a)
	return self

var _signiture: String
func get_signiture() -> String:
	var arr := PackedStringArray()
	if _signiture.length() == 0:
		arr.append(name)
		for arg in args:
			arr.append('[%s: %s] ' % [arg.name, Argument.type_names[arg.type]])
		_signiture = ''.join(arr)
	return _signiture

var _color: String
func get_color() -> String:
	if _color.length() == 0:
		const colors := [
		'ff7085','abc8ff','57b3ff',
		'ff7085','bce0ff','42ffc2',
		'42ffc2','8effda','ffeca1',
		'63c259',]
		_color = colors[hash(name)%colors.size()]
	return _color
