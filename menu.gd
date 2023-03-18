extends Control

const EXIT_GAME = "Exit game?"
const TOP_CLOUDS_SPEED = -25
const MIDDLE_CLOUDS_SPEED = 15
@onready var confirmation_dialog := $ConfirmationDialog
@onready var start_game_button := $Options/StartButton
@onready var top_clouds := $ParallaxBackground/TopClouds
@onready var middle_clouds := $ParallaxBackground/MiddleClouds


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	confirmation_dialog.hide()
	start_game_button.grab_focus()


func _process(delta):
	top_clouds.motion_offset.x += TOP_CLOUDS_SPEED * delta
	middle_clouds.motion_offset.x += MIDDLE_CLOUDS_SPEED * delta


func _on_exit_button_pressed():
	confirmation_dialog.popup_message(EXIT_GAME)


func _on_confirmation_dialog_confirmed():
	get_tree().quit()


func _on_start_button_pressed():
	BackgroundLoader.load_scene("res://ui/levels_menu.tscn")


func _on_controlls_button_pressed():
	BackgroundLoader.load_scene("res://ui/controls_menu.tscn")
