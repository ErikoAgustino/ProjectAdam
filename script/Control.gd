extends Control



func _on_settings_pressed():
	get_tree().change_scene("res://Settings.tscn")


func _on_continue2_pressed():
	get_tree().change_scene("res://World.tscn")


func _on_exit_pressed():
	get_tree().quit()
