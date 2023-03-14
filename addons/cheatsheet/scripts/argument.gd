extends RefCounted

const BaseType := preload('res://addons/cheatsheet/scripts/type/base_type_regex.gd')

var _name: String
var _type: BaseType
var _defualt: Variant
var _info: String

func _init(name: String, type: BaseType, defualt: Variant, info: String) -> void:
	_name = name
	_type = type
	_defualt = defualt
	_info = info
