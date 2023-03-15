@tool
extends EditorPlugin

const PLUGIN_NAME = 'Console'
const PLUGIN_PATH = 'res://addons/cheatsheet/cheatsheet.tscn'

func _enter_tree() -> void:
	add_autoload_singleton(PLUGIN_NAME, PLUGIN_PATH)

func _exit_tree() -> void:
	remove_autoload_singleton(PLUGIN_NAME)
