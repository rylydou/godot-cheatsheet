extends RefCounted

const Argument := preload('res://addons/cheatsheet/scripts/argument.gd')

var name: String
var callback: Callable
func _init(name: String, callback: Callable) -> void:
	self.name = name
	self.callback = callback

var toolong: String
func tldr(text: String):
	toolong = text
	return self

var description: String
func desc(text: String):
	description = text
	return self

var args: Array[Argument]
func arg(name: String, type: Variant.Type, defualt = null, info := ''):
	var a := Argument.new(name, type, defualt, info)
	args.append(a)
	return self
