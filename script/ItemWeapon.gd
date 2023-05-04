tool

extends Node2D

export(String, "Common", "Rare", "Legendary") var quality = "Common" 
export var names : String
export var texture : Texture
export var strenght : int
export var strenghtRequire : int
export var agility : int
export var agilityRequire : int
export var intelligence : int
export var intelligenceRequire : int

func _get_configuration_warning():
	if(names == ""):
		return "Weapon name require"
	if(texture == null):
		return "Weapon texture require"
	return ""
