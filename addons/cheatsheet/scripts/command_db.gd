extends RefCounted

const Command := preload('res://addons/cheatsheet/scripts/command.gd')
const Argument := preload('res://addons/cheatsheet/scripts/argument.gd')

var commands: Dictionary

func register(name: String, callback: Callable) -> Command:
	var command := Command.new(name, callback)
	
	if commands.has(name):
		commands[name].append(command)
	else:
		commands[name] = [command]
	
	return command

func run(str: String) -> void:
	var name := str.substr(0, str.find(' '))
	var args := get_args(str.substr(name.length() + 1))
	var command := find_command(name, args)
	if not command: return
	
	var real_args := []
	for i in args.size():
		var input_arg := args[i] 
		var command_arg := command.args[i]
		real_args.append(command_arg.convert(input_arg))
	command.callback.callv(real_args)

func find_command(name: String, args: Array[String]) -> Command:
	var command: Command
	
	if not self.commands.has(name):
		Console.error("unknown command '%s'" % name)
		return null
	var commands: Array = self.commands[name]
	
	if commands.size() == 1:
		command = commands[0]
		# check argument count
		if not command.args.size() == args.size():
			Console.error("expected %s arguments but got %s" % [command.args.size(), args.size()])
			return null
		# check argument types
		for i in args.size():
			var input_arg := args[i] 
			var command_arg := command.args[i]
			if not command_arg.check(input_arg):
				var exp_name := Argument.type_names[command_arg.type]
				Console.error(
					"expected type of '%s' for '%s' but got '%s'" %
					[exp_name, command_arg.name, input_arg]
				)
				return null
		return command
	
	# using `Array.filter` causes a crash for some reason
	var new_commands := []
	for c in commands:
		if c.args.size() == args.size():
			new_commands.append(c)
	commands = new_commands
	
	if commands.size() == 0:
		Console.error("couldn't find command with %s arguments" % [args.size()])
		return null
	for c in commands:
		var perfect_flag := true
		for i in args.size():
			var input_arg := args[i] 
			var command_arg: Argument = c.args[i]
			if not command_arg.check(input_arg):
				perfect_flag = false
				break
		if perfect_flag:
			return c
	
	Console.error("couldn't find command with those argument types")
	return null

func get_args(str: String) -> PackedStringArray:
	var args: PackedStringArray
	
	var word: PackedStringArray
	var submit: Callable = func () -> void:
		var s := ''.join(word)
		word.clear()
		if s.length() == 0: return
		args.append(s)
	
	var is_start := true
	var is_str := false
	var is_escape := false
	for ch in str.split():
		if is_str:
			if is_escape:
				is_escape = false
				match ch:
					'n': word.append('\n')
					't': word.append('\t')
					'b': word.append('\b')
					var c: word.append(c)
				continue
			
			if ch == '\\':
				is_escape = true
				continue
			
			if ch == "'":
				is_str = false
				continue
			
			word.append(ch)
			continue
		
		# start of string
		if is_start:
			is_start = false
			if ch == "'":
				is_str = true
				continue
		
		# normal argument
		word.append(ch)
		
		if ch == ' ':
			is_start = true
			submit.call()
			continue
	
	submit.call()
	
	return args
