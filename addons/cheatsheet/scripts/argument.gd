extends RefCounted

var name: String
var type: Variant.Type

func _init(name: String, type: Variant.Type) -> void:
	if type >= regexes.size() or regexes[type] == null:
		printerr('type of %s is unsupported' % type)
	self.name = name
	self.type = type

const type_names: Array[String] = [
	'any',
	'bool',
	'int',
	'float',
	'string',
	'vector2',
	'vecor2i',
	'rect2',
	'rect2i',
	'vector3',
	'vector3i',
]

var regexes: Array[RegEx] = [
	RegEx.create_from_string('.*'), # any
	RegEx.create_from_string('^true|false|t|f|yes|no|y|n|1|0$'), # bool
	RegEx.create_from_string('^[+-]?\\d+$'), # int
	RegEx.create_from_string('^[+-]?((\\d*\\.\\d+)|(\\d+\\.\\d*)|(\\d+))$'), # flt
	RegEx.create_from_string('.*'), # str
	RegEx.create_from_string('^[+-]?((\\d*\\.\\d+)|(\\d+\\.\\d*)|(\\d+)),[+-]?((\\d*\\.\\d+)|(\\d+\\.\\d*)|(\\d+))$'), # vec2
	RegEx.create_from_string('^[+-]?\\d+,[+-]?\\d+$'), # vec2i
	null, # rect2
	null, # rect2i
	RegEx.create_from_string('^[+-]?((\\d*\\.\\d+)|(\\d+\\.\\d*)|(\\d+)),[+-]?((\\d*\\.\\d+)|(\\d+\\.\\d*)|(\\d+)),[+-]?((\\d*\\.\\d+)|(\\d+\\.\\d*)|(\\d+))$'), # vec3
	RegEx.create_from_string('^[+-]?\\d+,[+-]?\\d+,[+-]?\\d+$'), # vec3i
]

func check(string: String) -> bool:
	var regex := regexes[type]
	var rematch := regex.search(string)
	return rematch and rematch is RegExMatch

func convert(string: String) -> Variant:
	match type:
		TYPE_NIL: return string
		TYPE_BOOL: return string == 'true' or string == 't' or string == 'yes' or string == 'y' or string == '1'
		TYPE_INT: return int(string)
		TYPE_FLOAT: return float(string)
		TYPE_STRING: return string
		TYPE_VECTOR2: 
			var segs := string.split(',', false, 2)
			return Vector2(float(segs[0]), float(segs[1]))
		TYPE_VECTOR2I:
			var segs := string.split(',', false, 3)
			return Vector3(float(segs[0]), float(segs[1]), float(segs[2]))
		TYPE_VECTOR3:
			var segs := string.split(',', false, 2)
			return Vector2(int(segs[0]), int(segs[1]))
		TYPE_VECTOR3I:
			var segs := string.split(',', false, 3)
			return Vector3(int(segs[0]), int(segs[1]), int(segs[2]))
	return null
