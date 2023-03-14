extends 'res://addons/cheatsheet/scripts/type/base_type_regex.gd'

func _init():
	super._init('float', '^[+-]?([0-9]*[\\.\\,]?[0-9]+|[0-9]+[\\.\\,]?[0-9]*)([eE][+-]?[0-9]+)?$')

func normalize(value: Variant) -> Variant:
	return float(_reextract(value).replace(',', '.'))
