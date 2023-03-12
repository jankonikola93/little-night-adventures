extends Node2D

@export_enum("CLOCKWISE", "COUNTER-CLOCKWISE") var rotation_direction : int = 0
@onready var animation_player := $AnimationPlayer
@onready var segments := $Segments.get_children()


func _ready():
	match rotation_direction:
		0:
			animation_player.play("rotate_clockwise")
		1:
			animation_player.play("rotate_counterclockwise")
	for x in segments:
		x.set_rotation_direction(rotation_direction)
