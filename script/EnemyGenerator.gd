extends Node2D

const Slime = preload("res://scene/enemy/Slime2.tscn")

var timer = 0

func _process(delta):
	timer += delta
	if(timer > 3):
		timer = 0
		generateSlime()

func generateSlime():
	var slime = Slime.instance()
	slime.global_position = global_position
#	slime.setFollowPlayer(true)
	slime.path_to_player = NodePath("../Player")
	get_parent().add_child(slime)
