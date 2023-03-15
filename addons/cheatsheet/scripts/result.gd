extends RefCounted

var result: Variant
var message: String

func _init(result: Variant, message := '') -> void:
	self.result = result
	self.message = message

func has_result() -> bool:
	return result != null
