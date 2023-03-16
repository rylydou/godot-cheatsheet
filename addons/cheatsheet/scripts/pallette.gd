extends Control

@onready var command_list: ItemList = %CommandList

var commands: Array[CsCommand] = []

func update_list() -> void:
	commands.clear()
	command_list.clear()
	for collection in Console.db.commands.values():
		for command in collection:
			command_list.add_item(command.get_signiture())
			commands.append(command)

func _on_cheatsheet_commands_changed() -> void:
	update_list()

func _on_command_list_item_activated(index: int) -> void:
	commands[index].callback.callv([])
