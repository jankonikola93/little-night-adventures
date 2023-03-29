extends Popup

const MAX_STARS := 3
@onready var play_button := $Background/Buttons/PlayButton
@onready var stars := $Background/Stars


func popup_with_stars(stars_to_fill: int):
	popup_centered()
	if stars_to_fill > MAX_STARS:
		stars_to_fill = MAX_STARS
	for i in stars_to_fill:
		stars.get_child(i).fill()
		await get_tree().create_timer(0.5).timeout


func _on_play_button_pressed():
	hide()


func _on_about_to_popup():
	play_button.grab_focus()
