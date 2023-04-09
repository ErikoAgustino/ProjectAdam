extends Node2D

var item_name
var item_quantity

var quality
var strenght : int
var agility : int
var intelligence : int
var intelligenceRequire : int
var texture

func _ready():
#	var rand_val = randi() % 3
#	if rand_val == 0:
#		item_name = "Iron Sword"
#	elif rand_val == 1:
#		item_name = "Tree Branch"
#	else:
#		item_name = "Slime Potion"
	
#	$TextureRect.texture = load("res://Asset/Texture/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
#	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = String(item_quantity)

func set_item(item):
	item_name = item[0]
	item_quantity = item[1]
	if(item.size() > 2):
		quality = item[2]
		strenght = item[3]
		agility = item[4]
		intelligence = item[5]
		intelligenceRequire = item[6]
	texture = load("res://Asset/Texture/" + item_name + ".png")
	$TextureRect.texture = texture
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)

func toArray():
	return [item_name, item_quantity, quality, strenght, agility, intelligence, intelligenceRequire]

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)
	
