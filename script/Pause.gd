extends Control

var is_paused = false setget set_is_paused

func _ready():
	visible = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_resume_pressed():
	self.is_paused = false

func _on_settings_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	self.is_paused = false
	get_tree().change_scene("res://scene/ui/MainMenu.tscn")
