extends Node2D

const Slime = preload("res://scene/enemy/Slime.tscn")

var timer = 0

func _process(delta):
	timer += delta
	if(timer > 3):
		timer = 0
		generateSlime()

func generateSlime():
	var slime = Slime.instance()
	slime.position = global_position
	slime.path_to_player = NodePath("../../Player")
	add_child(slime)
