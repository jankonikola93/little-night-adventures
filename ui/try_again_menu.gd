extends Popup

@onready var play_button := $Background/PlayButton
@onready var lifes_label := $Background/LifesCounter/Label


func popup_menu(lifes: int):
	lifes_label.text = "X %s" % lifes
	popup_centered()


func _on_play_button_pressed():
	hide()


func _on_about_to_popup():
	play_button.grab_focus()
