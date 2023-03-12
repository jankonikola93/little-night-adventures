class_name Oscilator
extends SpawnPosition

const OSCILATE_BEHAVIOR := 2
@export_range(0, 100) var amount := 0
@export_range(0, 100) var frequency := 3.0
@export_range(1, 1000) var amplitude := 400.0
@export var speed : float = 300.0
var counter := 0


func _spawn_element():
	if counter > amount and amount > 0:
		timer.stop()
		return
	var element = element_to_spawn.instantiate()
	element.global_position = global_position
	if element.has_method("set_direction"):
		element.set_direction(direction)
	if element.has_method("set_behavior"):
		element.set_behavior(OSCILATE_BEHAVIOR)
	if element.has_method("connect_visible_notifier"):
		element.connect_visible_notifier()
	element.speed = speed
	element.frequency = frequency
	element.amplitude = amplitude
	element.add_to_group("remove_on_try_on")
	get_parent().add_child(element)
	counter += 1
