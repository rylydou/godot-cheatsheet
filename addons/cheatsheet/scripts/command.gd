extends RefCounted

const Argument := preload('res://addons/cheatsheet/scripts/argument.gd')
const BaseType := preload('res://addons/cheatsheet/scripts/type/base_type.gd')

var _name: String
var _callback: Callable

func _init(name: String, callback: Callable) -> void:
	_name = name
	_callback = callback

var _tldr: String
func tldr(text: String):
	_tldr = text
	return self

var _description: String
func description(text: String):
	_description = text
	return self

var _args: Array[Argument]
func arg(name: String, type: Variant.Type, defualt = null, info := ''):
	var a := Argument.new(name, create_type(type), defualt, info)
	_args.append(a)
	return self

const TYPE_LIST: Array[Resource] = [
	preload('res://addons/cheatsheet/scripts/type/any_type.gd'),
	preload('res://addons/cheatsheet/scripts/type/bool_type.gd'),
	preload('res://addons/cheatsheet/scripts/type/int_type.gd'),
	preload('res://addons/cheatsheet/scripts/type/float_type.gd'),
	preload('res://addons/cheatsheet/scripts/type/string_type.gd'),
	# vec2
	# rect2
	# vec3
	# rect3
]

static func create_type(engine_type: Variant.Type) -> BaseType:
	if engine_type >= 0 and engine_type < TYPE_LIST.size() and TYPE_LIST[engine_type] != null:
		return TYPE_LIST[engine_type].new()
	return null
