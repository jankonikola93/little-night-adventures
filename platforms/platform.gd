extends StaticBody2D

@export var pulsing : bool = false
@export_enum("Visibile", "Hidden") var start_state : int = 0
@onready var animation_player := $AnimationPlayer

func _ready():
	if not pulsing:
		return
	match start_state:
		0: animation_player.play("pulse1")
		1: animation_player.play("pulse2")
