extends Node2D

export (int, "Sword", "Bow", "Staff") var weaponType
export (int, "Common", "Rare", "Epic") var rarity
export (String) var weaponName = "" 
export (String) var strReq = 0
export (String) var agiReq = 0
export (String) var intReq = 0
export (String) var dmg = 0

var item = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if (weaponType != ""):
		setItem(get_node(weaponType).getInstance())

func setItem(paramItem):
	item = paramItem
	
func getItem():
	return item
	

