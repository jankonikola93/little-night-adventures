class_name SpinnerSegment
extends Sprite2D

@export_enum("CLOCKWISE", "COUNTER-CLOCKWISE") var rotation_direction : int = 0
@onready var animation_player := $AnimationPlayer

func _ready():
	_play_animation()

func set_rotation_direction(value: int):
	if value not in range(2):
		return
	rotation_direction = value
	_play_animation()

func _play_animation():
	match rotation_direction:
		0: animation_player.play("rotate_clockwise")
		1: animation_player.play("rotate_counterclockwise")
