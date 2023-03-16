extends CanvasLayer

const DUST_EXPLOSION_EFFECT = preload("res://effects/dust_explosion.tscn")
const DUST_EXPLOSION_EFFECT_SCALE := Vector2(0.5, 0.5)
@onready var lifebar := $LifeBar

func set_lifebar(lifes: int):
	var life_indicator
	if lifes == 0:
		life_indicator = lifebar.get_children()[0]
	else:
		life_indicator = lifebar.get_children()[-lifebar.get_child_count() + lifes]
	life_indicator.hide()
	_add_dust_explosion(life_indicator.global_position)


func _add_dust_explosion(spawn_position: Vector2):
	var dust_explosion = DUST_EXPLOSION_EFFECT.instantiate()
	dust_explosion.scale = DUST_EXPLOSION_EFFECT_SCALE
	dust_explosion.process_mode = Node.PROCESS_MODE_ALWAYS
	dust_explosion.global_position = spawn_position
	get_parent().add_child(dust_explosion)
