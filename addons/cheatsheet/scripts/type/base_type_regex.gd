extends 'res://addons/cheatsheet/scripts/type/base_type.gd'

const BaseType := preload('res://addons/cheatsheet/scripts/type/base_type.gd')

var _pattern: String
var _regex: RegEx

# @param  String  name
# @param  String  pattern
func _init(name:String, pattern:String):
	super._init(name)
	_pattern = pattern
	_regex = RegEx.new()
	_regex.compile(_pattern)

func check(value: Variant) -> BaseType.Check:
	return BaseType.Check.OK if _reextract(value) else BaseType.Check.FAILED

func _reextract(value: Variant) -> Variant:
	var rematch = self._regex.search(value)

	if rematch and rematch is RegExMatch:
		return rematch.get_string()

	return null
