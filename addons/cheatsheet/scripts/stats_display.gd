extends MarginContainer

func _ready() -> void:
	find_child('MemLabel')

func _process(delta: float) -> void:
	if not visible: return
	
	var fps := Performance.get_monitor(Performance.TIME_FPS)
	var process_time := Performance.get_monitor(Performance.TIME_PROCESS)
	var physics_process_time := Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)
	
	#var mem_static := Performance.get_monitor(Performance.MEMORY_STATIC)
	
	var obj_count := Performance.get_monitor(Performance.OBJECT_COUNT)
	var node_count := Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
	
	var video_mem := Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)
	
	find_child('TimeLabel').text = 'TIME: %sfps (pro:%dms phy:%dms)' % [fps, process_time*1000, physics_process_time*1000]
	#find_child('MemLabel').text = 'MEM: %0.2fMB' % [mem_static/1_048_576]
	find_child('ObjLabel').text = 'OBJ: %4s (%s nodes)' % [obj_count, node_count]
	find_child('RenderLabel').text = 'RENDER: %0.2fMB'
