extends Node2D

@onready var dust_left := $DustLeft
@onready var dust_right := $DustRight

func _ready():
	dust_left.emitting = true
	dust_right.emitting = true
