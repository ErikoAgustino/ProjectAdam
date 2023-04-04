extends Node

var next_level = null
export (String) var level_name = "level1"

onready var current_level = $Level1 

func _ready():
	current_level.connect("level_changed",self, "_on_level_changer_level_changed")

func _process(delta):
	if(Input.is_action_just_pressed("change_scene")):
		changer_level_changed(level_name)
		emit_signal("level_changed", level_name)
	if(Input.is_action_just_pressed("ui_accept")):
		current_level.get_node("Player").class_stat.levelup()

func changer_level_changed(current_level_name : String):
	var next_level_name : String
	
	match current_level_name:
		"level1":
			next_level_name = "level2"
		"level2":
			next_level_name = "level1"
		_:
			return
	
	next_level =  load("res://scene/level/" + next_level_name + ".tscn").instance()
	add_child(next_level)
	next_level.connect("level_changed", self, "changer_level_changed")
	transfer_data(current_level, next_level)
	current_level.queue_free()
	current_level=next_level

func transfer_data(current, to):
	to.load_level_parameters(current.stat, current.weapon)
