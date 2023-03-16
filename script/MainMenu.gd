extends Control



func _on_ExitButton_pressed():
	get_tree().quit()

func _on_SettingButton_pressed():
	get_tree().change_scene("res://scene/ui/Settings.tscn")
