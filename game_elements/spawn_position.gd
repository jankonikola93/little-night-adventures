class_name SpawnPosition
extends Marker2D

@export var element_to_spawn : PackedScene
@export_range(-1, 1, 2) var direction : int
@export var spawn_time : float = 1.0
@onready var timer := $Timer
var enabled := false


func _spawn_element():
	var element = element_to_spawn.instantiate()
	element.global_position = global_position
	if element.has_method("set_direction"):
		element.set_direction(direction)
	element.add_to_group("remove_on_try_on")
	get_parent().add_child(element)


func _on_timer_timeout():
	if not enabled:
		return
	_spawn_element()


func _on_visible_on_screen_notifier_2d_screen_entered():
	_spawn_element()
	timer.wait_time = spawn_time
	timer.start()
	enabled = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	enabled = false
	timer.stop()
