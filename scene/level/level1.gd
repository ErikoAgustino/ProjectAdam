extends Node2D

signal level_changed(level_name)

onready var stat=get_node("Player").class_stat
onready var weapon=get_node("Player").weapons


func load_level_parameters(stats, weapons):
	print(stat.level,"-",weapon.name)
	print(stats.level,"-",weapons.name)	
	stat=stats
	weapon=weapons
	print(stat.level,"-",weapon.name)
	
