extends Control


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		BackgroundLoader.load_scene("res://menu.tscn")
