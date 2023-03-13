class_name CommandDB extends RefCounted

var commands: Dictionary

func register(root: String, command: Callable) -> void:
	if commands.has(root):
		commands[root].append(command)
	else:
		commands[root] = [command]

func run(str: String) -> void:
	var root := str.substr(0, str.find(' '))
	print_debug('root:', root)
	if not commands.has(root): return
	
	var root_commands = commands[root]
	var args := get_args(str.substr(root.length() + 1))
	print_debug('args:', args)
	
	var command: Callable = root_commands[0]
	print_debug('method: ', command.get_method())
	print_debug('object: ', command.get_object())
	
	command.callv(args)

func get_args(str: String) -> PackedStringArray:
	var args: PackedStringArray
	
	var word: PackedStringArray
	var submit: Callable = func () -> void:
		var s := ''.join(word)
		if s.length() == 0: return
		args.append(s)
	
	var is_start := true
	var is_str := false
	var is_escape := false
	for ch in str.split():
		if is_str:
			if is_escape:
				is_escape = false
				word.append(ch)
				match ch:
					'n': word.append('\n')
					't': word.append('\t')
					'b': word.append('\b')
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
