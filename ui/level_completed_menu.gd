extends Popup

@onready var play_button := $Background/Buttons/PlayButton


func _on_play_button_pressed():
	hide()


func _on_about_to_popup():
	play_button.grab_focus()
