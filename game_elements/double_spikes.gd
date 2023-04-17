extends AnimatableBody2D

@export var should_oscillate := false
@export_range(0, 100) var frequency := 3.0
@export_range(-20, 20) var amplitude := 10.0
var time := 0.0
var velocity := Vector2.ZERO


func _ready():
	if should_oscillate:
		sync_to_physics = false


func _physics_process(delta):
	if should_oscillate:
		_oscillate(delta)


func _oscillate(delta: float):
	time += delta
	velocity.y = sin(time * frequency) * amplitude
	var _c = move_and_collide(velocity)
