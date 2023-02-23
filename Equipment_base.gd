extends Node2D


export (int, "Head", "Body", "Arms", "Legging") var equipmentPart
export (int, "Common", "Rare", "Epic") var rarity
export (String) var equipmenName = "" 
export (String) var Str = 0
export (String) var agi = 0
export (String) var Int = 0
export (String) var defense = 0

var item = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if (equipmentPart != ""):
		setItem(get_node(equipmentPart).getInstance())

func setItem(paramItem):
	item = paramItem
	
func getItem():
	return item
