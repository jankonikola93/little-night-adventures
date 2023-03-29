extends TextureRect

const DUST_EXPLOSION_SCENE := preload("res://effects/dust_explosion.tscn")
const DUST_EXPLOSION_POSITION := Vector2(24, 27)
@export var texture_filled : Texture


func fill():
	var dust_explosion = DUST_EXPLOSION_SCENE.instantiate()
	dust_explosion.position = DUST_EXPLOSION_POSITION
	add_child(dust_explosion)
	texture = texture_filled
