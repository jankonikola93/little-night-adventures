@tool
extends TextureButton

const SIMULATED_DELAY_SEC = 1
@export_range(1, 100) var level_number : int = 1
@export_enum("LOCKED: -1", "UNLOCKED: 0", "1Star: 1", "2Stars: 2", "3Stars: 3") var status : int = -1
@export var unlocked_texture : Texture
@export var one_star_texture : Texture
@export var two_stars_texture : Texture
@export var three_stars_texture : Texture
@export var unlocked_focused_texture : Texture
@export var one_star_focused_texture : Texture
@export var two_stars_focused_texture : Texture
@export var three_stars_focused_texture : Texture
@onready var label := $Label


func _ready():
	label.text = "Level %s" % level_number
	_set_textures()


func _set_textures():
	match status:
		-1:
			disabled = true
		0:
			texture_normal = unlocked_texture
			texture_focused = unlocked_focused_texture
			texture_hover = unlocked_focused_texture
			disabled = false
		1:
			texture_normal = one_star_texture
			texture_focused = one_star_focused_texture
			texture_hover = one_star_focused_texture
			disabled = false
		2:
			texture_normal = two_stars_texture
			texture_focused = two_stars_focused_texture
			texture_hover = two_stars_focused_texture
			disabled = false
		_:
			texture_normal = three_stars_texture
			texture_focused = three_stars_focused_texture
			texture_hover = three_stars_focused_texture
			disabled = false


func _on_pressed():
	BackgroundLoader.load_scene(
		"res://levels/level_%s.tscn" % level_number,
		SIMULATED_DELAY_SEC)
