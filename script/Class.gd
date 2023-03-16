tool
extends Node

class_name Class

onready var stats = $Stats

export var basestats : Resource

func _ready():
	stats.initialize(basestats)
#	print("level	: ",stats.level)
#	print("xp		: ",stats.xp)
#	print("xp req	: ",stats.xpreq)
#	print("Str		: ",stats.strenght)
#	print("Agi		: ",stats.agility)
#	print("Int		: ",stats.intelligence)
