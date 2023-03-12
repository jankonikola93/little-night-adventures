class_name BaseTextureButton
extends TextureButton

@export_range(1, 2) var zoom_level : float = 1.2


func _ready():
	var _e = connect("focus_entered", _on_focus_entered)
	_e = connect("focus_exited", _on_focus_exited)
	_e = connect("mouse_entered", _on_mouse_entered)
	_e = connect("mouse_exited", _on_mouse_exited)


func _zoom():
	scale = Vector2(zoom_level, zoom_level)


func _reset_zoom():
	scale = Vector2(1, 1)


func _on_focus_entered():
	_zoom()


func _on_focus_exited():
	_reset_zoom()


func _on_mouse_entered():
	_zoom()


func _on_mouse_exited():
	_reset_zoom()
