extends CharacterBody2D

const DISTANCE_CORRECTION := 5
@export var speed : float = 300.0
@export var acceleration : float = 25.0
@export var wait_time : float = 1.0
@export var patrol_length : int = 200
@onready var sprite := $Sprite
@onready var wait_timer := $WaitTimer
var target_destination = Vector2.ZERO
var path_points := PackedVector2Array()
var next_point_index := 0
var is_waiting := false
var current_speed := 0.0


func _ready():
	_initialize_path()


func _physics_process(_delta: float):
	_patrol()


func _patrol():
	if path_points.is_empty():
		return
	elif is_waiting:
		return
	else:
		_move_to(path_points[next_point_index])
	
	if _is_target_reached():
		current_speed = 0
		velocity.x = move_toward(velocity.x, 0, speed)
		if wait_timer.is_stopped():
			wait_timer.start(wait_time)
			is_waiting = true
		_set_next_point_index()
		return
	
	current_speed += acceleration
	current_speed = clamp(current_speed, -speed, speed)
	velocity.x = global_position.direction_to(target_destination).x * current_speed
	move_and_slide()
	sprite.flip_h = velocity.x < 0


func _move_to(value: Vector2):
	target_destination = value


func _is_target_reached() -> bool:
	return global_position.distance_to(target_destination) < DISTANCE_CORRECTION


func _set_next_point_index():
	next_point_index += 1
	if next_point_index >= path_points.size():
		next_point_index = 0


func _initialize_path():
	path_points.append(
		Vector2(global_position.x - patrol_length, global_position.y))
	path_points.append(
		Vector2(global_position.x + patrol_length, global_position.y))


func _on_wait_timer_timeout():
	is_waiting = false
