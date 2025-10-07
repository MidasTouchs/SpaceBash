extends Node


const SAVEFILE = "user://spacebash.save"

var level = 0
var score = 0

func _ready():
	load_number()

func save_number():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
	file.store_var(level)
	file.store_var(score)
	
func load_number():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		level = file.get_var()
		score = file.get_var()
