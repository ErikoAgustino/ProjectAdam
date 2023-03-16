tool
extends Node

class_name Equipments

onready var weapon_stat = $Weapons

export var baseweapons : Resource

func _ready():
	weapon_stat.initialize(baseweapons)
#	print("weapontype	: ",weapon_stat.weapontype)
#	print("quality		: ",weapon_stat.quality)
#	print("names		: ",weapon_stat.names)
#	print("strenght		: ",weapon_stat.strenght)
#	print("agility		: ",weapon_stat.agility)
#	print("intelligence	: ",weapon_stat.intelligence)
#	print("strreq		: ",weapon_stat.strreq)
#	print("agireq		: ",weapon_stat.agireq)
#	print("intreq		: ",weapon_stat.intreq)

