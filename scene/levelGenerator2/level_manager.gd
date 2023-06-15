extends Node2D

var borders = Rect2(-28,-28,56,56)

onready var tileMap = $grass_wall

func _ready():
	randomize()
	generate_level()

func generate_level():
	var level = LevelGenerator.new(Vector2(-16,-16), borders)
	var map = level.walk(800)
	level.queue_free()
	for location in map :
		tileMap.set_cellv(location, 1)
	tileMap.update_bitmask_region(borders.position, borders.end)
#
#func _input(event):
#	if event.is_action_pressed("ui_up", true):
#		$Node2D.position.y -= 8
#	elif event.is_action_pressed("ui_down", true):
#		$Node2D.position.y += 8
#	elif event.is_action_pressed("ui_left", true):
#		$Node2D.position.x -= 8
#	elif event.is_action_pressed("ui_right", true):
#		$Node2D.position.x += 8
#
#	if event.is_action_pressed("scroll_up"):
#		$Node2D.zoom.x -= 0.5
#		$Node2D.zoom.y -= 0.5
#	if event.is_action_pressed("scroll_down"):
#		$Node2D.zoom.x += 0.5
#		$Node2D.zoom.y += 0.5
