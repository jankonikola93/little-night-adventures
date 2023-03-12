extends Sprite2D


func _ready():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.connect("finished", _on_tween_finished)

func _on_tween_finished():
	queue_free()
