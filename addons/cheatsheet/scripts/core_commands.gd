extends Object

const Command := preload('res://addons/cheatsheet/scripts/command.gd')
const Argument := preload('res://addons/cheatsheet/scripts/argument.gd')

func register() -> void:
	Console.register('help',
		func():
			var arr := PackedStringArray()
			arr.append("[color=gray]Type '[color=ff8ccc]help [lb]command[rb][/color]' to get more info on a command.\n'?' means there are more than one way of calling it.[/color]\n\n")
			
			var index := 1
			for name in Console.db.commands:
				var collection:Array = Console.db.commands[name]
				var command: Command = collection[0]
				arr.append('[color=%s]' % command.get_color())
				var txt := command.name
				if collection.size() > 1:
					txt += '?'
				
				arr.append('%-12s' % txt)
				
				if index % 5 == 0:
					arr.append('\n')
				
				arr.append('[/color]')
				index += 1
			Console.println(''.join(arr))
	).info('prints a list of all the commands')
	Console.register('help',
		func(name: String):
			if not Console.db.commands.has(name):
				Console.error('unknown command %s' % name)
				return
			
			var commands: Array = Console.db.commands[name]
			var arr := PackedStringArray()
			for command in commands:
				arr.append('[color=%s]%s[/color] ' % [command.get_color(), command.name])
				for arg in command.args:
					arr.append('[lb]%s: %s[rb] ' % [arg.name, Argument.type_names[arg.type]])
				arr.append('\n\t[color=gray]%s[/color]\n' % command.infos)
			Console.println(''.join(arr))
	).arg('command', TYPE_STRING)\
		.info('prints information about a specific command')
	
	Console.register('clear', Console.console.clear)\
		.info('clears the console')
	
	Console.register('info',
		func():
			Console.println('[b][lb]%s[rb][/b]' % ProjectSettings.get_setting('application/config/name'))
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
	).info('prints info about the current enviorment')
	
	Console.register('quit', Console.get_tree().quit)\
		.arg('code', TYPE_INT)\
		.info('quits the app')
	Console.register('crash', OS.crash)\
		.arg('message', TYPE_STRING)\
		.info('crashes the app')
	
	Console.register('reload', Console.get_tree().reload_current_scene)\
		.info('reloads tree')
	
	if OS.has_feature("standalone"):
		Console.register('relaunch',
			func():
				OS.set_restart_on_exit(true)
				Console.get_tree().quit()
		).info("closes then reopens the app")
	
	Console.register('fullscreen', func():
		if Console.get_window().mode == Window.MODE_FULLSCREEN:
			Console.println('going windowed...')
			Console.get_window().mode = Window.MODE_WINDOWED
		else:
			Console.println('going fullscreen...')
			Console.get_window().mode = Window.MODE_FULLSCREEN
	).info('toggles fullscreen the current window')
	
	Console.register('userdir', func():
		var dir := OS.get_user_data_dir()
		Console.println('[url=%s]%s[/url]' % [dir, dir])
		OS.shell_open(dir)
	).info('opens the user:// directory (where save data is stored)')
	
	Console.register('stats', Console.toogle_stats)\
		.info('toggles shows some basic stats about performance')
	
	Console.register('timescale', func(): Console.println('timescale: %s' % Engine.time_scale))\
		.info('gets the engine timescale')
	Console.register('timescale', func(time_scale: float): Engine.time_scale = time_scale)\
		.arg('time_scale', TYPE_FLOAT)\
		.info('sets the engine timescale, lower means slower')
	Console.register('maxfps', func(fps: int): Engine.max_fps = fps)\
		.arg('fps', TYPE_INT)\
		.info('sets the maxinum fps the engine should run at 0 means no limit as long as vsync is disable')
	Console.register('vsync',
		func(state: bool):
			DisplayServer.window_set_vsync_mode(
				DisplayServer.VSYNC_ENABLED if state else DisplayServer.VSYNC_DISABLED
			)
	).arg('enable', TYPE_BOOL)\
	.info('sets the vsync state of the current window - enabling will target the fps of current the display')
	
	Console.register('physics',
		func():
			Console.get_tree().debug_collisions_hint = not Console.get_tree().debug_collisions_hint
			Console.println('on' if Console.get_tree().debug_collisions_hint else 'off')
	).info('toggles showing collision shapes')
	
	Console.register('nav',
		func():
			Console.get_tree().debug_navigation_hint = not Console.get_tree().debug_navigation_hint
			Console.println('on' if Console.get_tree().debug_navigation_hint else 'off')
	).info('toggles showing navigation')
	
	Console.register('paths',
		func():
			Console.get_tree().debug_paths_hint = not Console.get_tree().debug_paths_hint
			Console.println('on' if Console.get_tree().debug_paths_hint else 'off')
	).info('toggles showing paths')
