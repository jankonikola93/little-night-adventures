class_name Witch
extends CharacterBody2D

@export_range(-1, 1, 2) var direction : int = -1
@export var speed : float = 600.0
@onready var sprite := $Sprite
@onready var sprite_offset : Vector2 = sprite.offset


func set_direction(value: int):
	if value == -1 or value == 1:
		direction = value


func _physics_process(_delta: float):
	velocity.x = direction * speed
	move_and_slide()
	_flip()


func _flip():
	if direction == 1:
		sprite.flip_h = true
		sprite.offset = Vector2(-sprite_offset.x, sprite_offset.y)
	else:
		sprite.flip_h = false
		sprite.offset = sprite_offset


func _on_visible_on_screen_notifier_screen_exited():
	call_deferred("queue_free")
