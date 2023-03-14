extends Node

func register() -> void:
	Cheatsheet.register('help', help)\
		.tldr('prints a list of all the commands')
	Cheatsheet.register('clear', clear)\
		.tldr('clears the console')
	Cheatsheet.register('print', Cheatsheet.println)\
		.arg('text', TYPE_STRING, null, 'the text to be printed')\
		.tldr('prints to the console')
	
	Cheatsheet.register('info', info)\
		.tldr('prints info about the current enviorment')
	
	Cheatsheet.register('quit', get_tree().quit)\
		.arg('code', TYPE_INT, 0, 'the exit code')\
		.tldr('quits the app')
	Cheatsheet.register('crash', OS.crash)\
		.arg('message', TYPE_STRING, '', 'the error message')\
		.tldr('HERE BE DRAGONS: crashes the app')
	
	Cheatsheet.register('reload', get_tree().reload_current_scene)\
		.tldr('reloads tree')
	Cheatsheet.register('relaunch',
		func():
			OS.set_restart_on_exit(true)
			get_tree().quit()
	).tldr("closes then reopens the app, doesn't work in the editor")
	
	Cheatsheet.register('fullscreen', func():
		if get_window().mode == Window.MODE_FULLSCREEN:
			Cheatsheet.println('going windowed...')
			get_window().mode = Window.MODE_WINDOWED
		else:
			Cheatsheet.println('going fullscreen...')
			get_window().mode = Window.MODE_FULLSCREEN
	).tldr('toggles fullscreen the current window')
	
	Cheatsheet.register('user', func():
		var dir := OS.get_user_data_dir()
		Cheatsheet.println('[url=%s]%s[/url]' % [dir, dir])
		OS.shell_open(dir)
	).tldr('opens the user:// directory (where save data is stored)')

func help() -> void:
	var index := 1
	for name in db.commands:
		Cheatsheet.println(str(index) + '. ' + name)
		index += 1

func clear() -> void:
	Cheatsheet.console.clear()

func info() -> void:
	printlb('Engine')
	println('%s %s' % [Engine.get_version_info().string, Engine.get_architecture_name()])
	printlb('OS')
	println('%s %s [color=cdcfd280]#%s[/color]' % [OS.get_name(), OS.get_version(), OS.get_unique_id()])
	printlb('CPU')
	# I don't care if there will be bad gramer for people with one core CPUs
	println('%s with %s cores' % [OS.get_processor_name(), OS.get_processor_count()])
	printlb('GPU')
	println('%s' % [OS.get_video_adapter_driver_info()])
	
	println('')
	
	printlb('Screen')
	println('%s %spi %shz' % [DisplayServer.screen_get_size(), DisplayServer.screen_get_dpi(), round(DisplayServer.screen_get_refresh_rate())])
	printlb('Window')
	println('%s %s' % [get_window().size, get_window().mode])
	printlb('Viewport')
	println('%s' % get_viewport().size)
