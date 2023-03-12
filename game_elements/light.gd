extends Area2D

signal light_turned_on

@export var second_texture : Texture
@export var second_texture_offset : Vector2 = Vector2.ZERO
@onready var sprite := $Sprite
var turned_on := false


func _turn_on():
	if turned_on:
		return
	sprite.texture = second_texture
	sprite.offset = second_texture_offset
	turned_on = true
	emit_signal("light_turned_on")


func _on_body_entered(body: Player):
	if body == null:
		return
	_turn_on()
