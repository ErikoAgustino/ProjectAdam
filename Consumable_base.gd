extends Node2D


export (int, "Heal", "Buff", "Debuff") var consumableType
export (int, "Common", "Rare", "Epic") var rarity
export (String) var consumableName = "" 
export (String) var heal = 0

var item = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if (consumableType != ""):
		setItem(get_node(consumableType).getInstance())

func setItem(paramItem):
	item = paramItem
	
func getItem():
	return item
