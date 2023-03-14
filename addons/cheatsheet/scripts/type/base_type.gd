enum Check {
	OK,
	FAILED,
	CANCELED
}

var _name: String

func _init(name: String):
	self._name = name

func check(value: Variant) -> Check:
	return Check.OK

func normalize(value: Variant) -> Variant:
	return value

func to_string() -> String:
	return self._name
