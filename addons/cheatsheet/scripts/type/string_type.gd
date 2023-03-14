extends 'res://addons/cheatsheet/scripts/type/base_type.gd'

func _init():
	super._init('string')

func normalize(value: Variant) -> Variant:
	return str(value)
