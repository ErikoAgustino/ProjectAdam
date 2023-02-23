extends Control

onready var music = get_node("VBoxContainer/HBoxContainer/MusicVolume")
onready var sound = get_node("VBoxContainer/HBoxContainer3/SoundVolume")
onready var resolution = get_node("VBoxContainer/HBoxContainer2/ResolutionButton")

func _ready():	
	resolution.add_item("1920x1080 Px (fullscreen)")
	resolution.add_item("1280x720 Px")
	resolution.add_item("960x540 Px")
	resolution.add_item("640x360 Px")
	updateResolution(0)

func updateResolution(index):
	var windowSize;
	match index:
		0:
			windowSize = Vector2(1920,1080)
			OS.set_window_fullscreen(true)
		1:
			windowSize = Vector2(1280,720)
			OS.set_window_fullscreen(false)
		2:
			windowSize = Vector2(960,540)
			OS.set_window_fullscreen(false)
		3:
			windowSize = Vector2(640,360)
			OS.set_window_fullscreen(false)
	
	var screenPosition = OS.get_screen_position(OS.get_current_screen())
	var screenSize = OS.get_screen_size()
	
	OS.set_window_size(windowSize)
	OS.set_window_position(screenPosition + screenSize * 0.5 - windowSize * 0.5)

func _on_ResolutionButton_item_selected(index):
	updateResolution(index)
