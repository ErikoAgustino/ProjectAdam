tool

extends Node

export(String, "Common", "Rare", "Legendary") var quality = "Common" 
export var names : String
export var texture : Texture
export var strenght : int
export var agility : int
export var intelligence : int
export var intelligenceRequire : int

func _get_configuration_warning():
	if(names == ""):
		return "Weapon name require"
	if(texture == null):
		return "Weapon texture require"
	return ""
