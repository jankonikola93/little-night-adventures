extends Popup

@onready var restart_button := $Background/Buttons/RestartButton


func _on_restart_button_pressed():
	hide()


func _on_about_to_popup():
	restart_button.grab_focus()
