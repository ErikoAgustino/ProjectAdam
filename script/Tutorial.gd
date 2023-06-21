extends Node2D

func _ready():
	$FadeScreen.fadeOut()
	get_node("Portal").connect("player_entered", self, "playerEnterPortal")

func playerEnterPortal():
	$FadeScreen.fadeIn()
	GameManager.currentLevel += 1
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().change_scene("res://scene/levelGenerator2/level_generator2.tscn")

