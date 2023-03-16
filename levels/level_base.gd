extends Node2D

@export_range(1, 100) var level_number : int = 1
@onready var right_boundary := $RightBoundary
@onready var player := $Player
@onready var lights := $Lights.get_children()
@onready var player_start_position : Vector2 = player.global_position
@onready var hud := $HUD
@onready var pause_menu := $PauseMenu
@onready var game_over_menu := $GameOverMenu
@onready var try_again_menu := $TryAgainMenu
@onready var level_completed_menu := $LevelCompletedMenu
var player_lifes := 3
var turned_lights := 0


func _ready():
	_hide_menues()
	_set_player()
	_set_lights()


func _hide_menues():
	pause_menu.hide()
	game_over_menu.hide()
	try_again_menu.hide()
	level_completed_menu.hide()


func _set_player():
	player.set_camera(Vector4(0, 0, right_boundary.position.x, 1080))


func _set_lights():
	for x in lights:
		if not x.is_connected("light_turned_on", _on_light_turned_on):
			x.connect("light_turned_on", _on_light_turned_on)


func _save_game_data():
	if turned_lights < 1:
		return
	var should_save := false
	if GameData.levels[level_number - 1] < turned_lights:
		GameData.levels[level_number - 1] = turned_lights
		should_save = true
	if GameData.levels[level_number] == -1:
		GameData.levels[level_number] = 0
		should_save = true
	if should_save:
		GameData.save()


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		pause_menu.popup_centered()


func _on_player_dead():
	get_tree().paused = true
	player_lifes -= 1
	hud.set_lifebar(player_lifes)
	if player_lifes <= 0:
		player.queue_free()
		game_over_menu.popup_centered()
	else:
		try_again_menu.popup_menu(player_lifes)


func _on_game_over_menu_popup_hide():
	get_tree().paused = false
	BackgroundLoader.load_scene("res://levels/level_%s.tscn" % level_number, 1)


func _on_try_again_menu_popup_hide():
	get_tree().call_group("remove_on_try_on", "queue_free")
	player.global_position = player_start_position
	player.reset()
	get_tree().paused = false


func _on_level_completed_menu_popup_hide():
	player.queue_free()
	get_tree().paused = false
	if GameData.levels[level_number + 1] > 0:
		BackgroundLoader.load_scene("res://levels/level_%s.tscn" % (level_number + 1), 1)
	else:
		BackgroundLoader.load_scene("res://levels/level_%s.tscn" % level_number, 1)


func _on_ending_area_body_entered(body: Player):
	if body == null:
		return
	get_tree().paused = true
	_save_game_data()
	level_completed_menu.popup_centered()


func _on_light_turned_on():
	turned_lights += 1
