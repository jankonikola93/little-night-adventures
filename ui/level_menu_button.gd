extends TextureButton


func _on_pressed():
	if get_tree().paused:
		get_tree().paused = false
	BackgroundLoader.load_scene("res://ui/levels_menu.tscn")
