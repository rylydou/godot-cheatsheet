extends 'res://addons/cheatsheet/scripts/type/base_type_regex.gd'

func _init():
	super._init('int', '^[+-]?\\d+$')

func normalize(value: Variant) -> Variant:
	return int(_reextract(value))
