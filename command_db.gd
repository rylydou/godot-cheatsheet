class_name CommandDB extends RefCounted

signal unknown_command(name: String)

var commands: Dictionary

func register(name: String, command: Callable) -> void:
	if commands.has(name):
		commands[name].append(command)
	else:
		commands[name] = [command]

func run(str: String) -> void:
	var name := str.substr(0, str.find(' '))
	if not commands.has(name):
		unknown_command.emit(name)
		return
	
	var root_commands = commands[name]
	var args := get_args(str.substr(name.length() + 1))
	#print('args:', args)
	
	var command: Callable = root_commands[0]
	
	command.callv(args)

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
