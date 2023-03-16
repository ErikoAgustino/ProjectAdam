extends Control

var is_paused = false setget set_is_paused

func _input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_resume_pressed():
	self.is_paused = false


func _on_quit_pressed():
	set_is_paused(false)
	get_tree().change_scene("res://Main Menu.tscn")
