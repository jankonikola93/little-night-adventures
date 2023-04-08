extends CharacterBody2D

const DISTANCE_CORRECTION := 5
@export_enum('PATROL: 1', 'OSCILATE: 2', 'OSCILATE_VERTICAL: 3') var behavior := 1
@export var speed : float = 300.0
@export var acceleration : float = 25.0
@export var wait_time : float = 1.0
@export var patrol_length : int = 200
@export_range(0, 100) var frequency := 3.0
@export_range(1, 1000) var amplitude := 400.0
@export_range(-1, 1, 2) var direction : int = 1
@onready var sprite := $Sprite
@onready var wait_timer := $WaitTimer
var target_destination = Vector2.ZERO
var path_points := PackedVector2Array()
var next_point_index := 0
var is_waiting := false
var current_speed := 0.0
var time := 0.0


func set_direction(value: int):
	if value == -1 or value == 1:
		direction = value


func set_behavior(value: int):
	behavior = value


func connect_visible_notifier():
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_visible_on_screen_notifier_2d_screen_exited)


func _ready():
	_initialize_path()


func _physics_process(delta: float):
	match behavior:
		1: _patrol()
		2: _oscilate(delta)
		3: _oscilate_vertical(delta)


func _oscilate(delta: float):
	time += delta
	var v = Vector2(direction * speed, 0)
	v.y = sin(time * frequency) * amplitude
	velocity = v
	move_and_slide()


func _oscilate_vertical(delta: float):
	time += delta
	var v = Vector2(0, direction * speed)
	v.x = sin(time * frequency) * amplitude
	velocity = v
	move_and_slide()


func _patrol():
	if path_points.is_empty():
		return
	elif is_waiting:
		return
	else:
		_move_to(path_points[next_point_index])
	
	if _is_target_reached():
		current_speed = 0
		velocity.y = move_toward(velocity.y, 0, speed)
		if wait_timer.is_stopped():
			wait_timer.start(wait_time)
			is_waiting = true
		_set_next_point_index()
		return
	
	current_speed += acceleration
	current_speed = clamp(current_speed, -speed, speed)
	velocity.y = global_position.direction_to(target_destination).y * current_speed
	move_and_slide()


func _move_to(value: Vector2):
	target_destination = value


func _is_target_reached() -> bool:
	return global_position.distance_to(target_destination) < DISTANCE_CORRECTION


func _set_next_point_index():
	next_point_index += 1
	if next_point_index >= path_points.size():
		next_point_index = 0


func _initialize_path():
	if patrol_length == 0:
		return
	path_points.append(
		Vector2(global_position.x, global_position.y - patrol_length))
	path_points.append(
		Vector2(global_position.x, global_position.y + patrol_length))


func _on_wait_timer_timeout():
	is_waiting = false


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
