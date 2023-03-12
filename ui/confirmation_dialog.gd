extends Popup

signal confirmed

@onready var label := $Background/Label
@onready var ok_button := $Background/Buttons/Ok


func popup_message(message: String):
	label.text = message
	ok_button.grab_focus()
	popup_centered()


func _on_NoButton_pressed():
	hide()


func _on_OkButton_pressed():
	emit_signal("confirmed")
