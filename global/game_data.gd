extends Node

const SAVEGAME_FILE_PATH : String = "user://savegame.dat"
const NUMBER_OF_LEVELS := 40
var levels := PackedInt32Array()


func _init():
	levels.append(0)
	for x in range(1, NUMBER_OF_LEVELS):
		levels.append(-1)


func _ready():
	_load()


func save():
	var savegame = FileAccess.open(SAVEGAME_FILE_PATH, FileAccess.WRITE)
	store_array(levels, savegame)
	savegame.close()


func _load():
	if not FileAccess.file_exists(SAVEGAME_FILE_PATH):
		return
	var savegame = FileAccess.open(SAVEGAME_FILE_PATH, FileAccess.READ)
	levels = get_array(savegame)
	savegame.close()


func store_array(array: Array, file: FileAccess):
	var json_array = JSON.stringify(array)
	file.store_32(json_array.length())
	file.store_string(json_array)


func get_array(file: FileAccess) -> Array:
	var array_length = file.get_32()
	var json_array = ""
	for _i in array_length:
		json_array += char(file.get_8())
	return JSON.parse_string(json_array)
