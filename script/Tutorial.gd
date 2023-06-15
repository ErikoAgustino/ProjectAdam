extends Node2D

func _ready():
	get_node("Portal").connect("player_entered", self, "playerEnterPortal")

func playerEnterPortal():
	get_tree().change_scene("res://scene/levelGenerator2/level_generator2.tscn")

