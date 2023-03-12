extends Control

var thread = null

func _thread_load(path, simulated_delay_seconds):
	var resource = null
	var _request = ResourceLoader.load_threaded_request(path)
	while true:
		OS.delay_msec(int(simulated_delay_seconds * 1000.0))
		var loading_status = ResourceLoader.load_threaded_get_status(path)
		match loading_status:
			1:
				continue
			3:
				resource = ResourceLoader.load_threaded_get(path)
				break
			_:
				print("There was an error loading resource")
				break
	call_deferred("_thread_done", resource)


func _thread_done(resource):
	assert(resource)
	thread.wait_to_finish()
	var new_scene = resource.instantiate()
	get_tree().current_scene.queue_free()
	get_tree().current_scene = null
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	hide()


func load_scene(path: String, simulated_delay_seconds: float = 0.1):
	var callable = Callable(self, "_thread_load")
	thread = Thread.new()
	thread.start(callable.bind(path, simulated_delay_seconds))
	show()
