@tool
extends Control

const LEVEL_BUTTON_SCENE = preload("res://ui/level_button.tscn")
@onready var grid_container := $ScrollContainer/GridContainer
@onready var scroll_container := $ScrollContainer


func _ready():
	var i = 1
	for x in GameData.levels:
		var level_button = LEVEL_BUTTON_SCENE.instantiate()
		level_button.level_number = i
		level_button.status = x
		grid_container.add_child(level_button)
		i += 1
	grid_container.get_children()[0].grab_focus()
