extends Object

const Command := preload('res://addons/cheatsheet/scripts/command.gd')
const Argument := preload('res://addons/cheatsheet/scripts/argument.gd')

func register() -> void:
	Console.register('help', help)\
		.tldr('prints a list of all the commands')
	Console.register('clear', clear)\
		.tldr('clears the console')
	Console.register('print', Console.println)\
		.arg('text', TYPE_STRING, null, 'the text to be printed')\
		.tldr('prints to the console')
	
	Console.register('info', info)\
		.tldr('prints info about the current enviorment')
	
	Console.register('quit', Console.get_tree().quit)\
		.arg('code', TYPE_INT, 0, 'the exit code')\
		.tldr('quits the app')
	Console.register('crash', OS.crash)\
		.arg('message', TYPE_STRING, '', 'the error message')\
		.tldr('crashes the app')
	
	Console.register('reload', Console.get_tree().reload_current_scene)\
		.tldr('reloads tree')
	
	if OS.has_feature("standalone"):
		Console.register('relaunch',
			func():
				OS.set_restart_on_exit(true)
				Console.get_tree().quit()
		).tldr("closes then reopens the app")
	
	Console.register('fullscreen', func():
		if Console.get_window().mode == Window.MODE_FULLSCREEN:
			Console.println('going windowed...')
			Console.get_window().mode = Window.MODE_WINDOWED
		else:
			Console.println('going fullscreen...')
			Console.get_window().mode = Window.MODE_FULLSCREEN
	).tldr('toggles fullscreen the current window')
	
	Console.register('userdir', func():
		var dir := OS.get_user_data_dir()
		Console.println('[url=%s]%s[/url]' % [dir, dir])
		OS.shell_open(dir)
	).tldr('opens the user:// directory (where save data is stored)')
	
	Console.register('timescale', func(time_scale: float): Engine.time_scale = time_scale)\
		.arg('time_scale', TYPE_FLOAT, null, '1.0 is the defualt')\
		.tldr('sets the engines timescale')
	# Console.register('timescale', func(): Console.println('timescale: %s' % Engine.time_scale))

func help() -> void:
	var arr := PackedStringArray()
	var is_even := false
	for name in Console.db.commands:
		var collection:Array = Console.db.commands[name]
		for command in collection:
			if is_even:
				arr.append('[color=cdcfd280]')
			gen_help_summary(arr, command)
			if is_even:
				arr.append('[/color]')
			is_even = not is_even
	Console.println(''.join(arr))

func gen_help_summary(arr: PackedStringArray, command: Command) -> void:
	arr.append('[color=ff8ccc]%16s[/color] %s\n' % [command.name, command.toolong])

func clear() -> void:
	Console.console.clear()

func info() -> void:
	Console.println('[b]%s[/b]' % ProjectSettings.get_setting('application/config/name'))
	Console.printlb('Godot')
	Console.println('%s %s' % [Engine.get_version_info().string, Engine.get_architecture_name()])
	Console.printlb('System')
	Console.println('%s %s uid:%s' % [OS.get_name(), OS.get_version(), OS.get_unique_id()])
	Console.printlb('CPU')
	# I don't care if there will be bad gramer for people with one core CPUs
	Console.println('%s with %s cores' % [OS.get_processor_name(), OS.get_processor_count()])
	Console.printlb('GPU')
	Console.println('%s' % [OS.get_video_adapter_driver_info()])
	
	Console.printlb('Screen')
	Console.println('%s %spi %shz' % [DisplayServer.screen_get_size(), DisplayServer.screen_get_dpi(), round(DisplayServer.screen_get_refresh_rate())])
	Console.printlb('Window')
	Console.println('%s %s' % [Console.get_window().size, Console.get_window().mode])
	Console.printlb('Viewport')
	Console.println('%s' % Console.get_viewport().size)
