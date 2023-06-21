extends Control

func _on_Button_pressed():
	SoundManager.stop("level")
	SoundManager.stop("boss")
	get_tree().change_scene("res://scene/ui/MainMenu.tscn")
