extends 'res://addons/cheatsheet/scripts/type/base_type.gd'

func _init():
	super._init('bool')

func normalize(value: Variant) -> Variant:
	return value == '1' or value == 'true' or value == 'yes' or value == 'y'
