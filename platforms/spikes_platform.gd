extends StaticBody2D

@export_enum("Down", "Up") var spikes_direction : int = 0
@onready var animation_player := $AnimationPlayer

func _ready():
	match spikes_direction:
		0: animation_player.play("rotate")
		1: animation_player.play("rotate2")
