extends Node2D

var borders = Rect2(-28,-28,56,56)

const Player = preload("res://scene/character/Player.tscn")
const PortalS = preload("res://scene/level/Portal.tscn")
const EnemyGenerator = preload("res://scene/enemy/EnemyGenerator.tscn")

onready var tileMap = $grass_wall

func _ready():
	randomize()
	generate_level()

func generate_level():
	var level = LevelGenerator.new(Vector2(0,0), borders)
	var map = level.walk(800)
	
	var player = Player.instance()
	player.position = map.front() * 64
	add_child(player)
	
	var portal = PortalS.instance()
	portal.position = level.get_end_room().position * 64
	add_child(portal)
	portal.connect("player_entered", self, "reloadLevel")
	
	var enemyGenerator = EnemyGenerator.instance()
	enemyGenerator.position = map[map.size() / 2] * 64
	add_child(enemyGenerator)
	
	level.queue_free()
	for location in map :
		tileMap.set_cellv(location, 1)
	tileMap.update_bitmask_region(borders.position, borders.end)

func reloadLevel():
	GameManager.currentLevel += 1
	if(GameManager.currentLevel % 5 == 0):
		get_tree().change_scene("res://scene/ui/MainMenu.tscn")
	else:
		get_tree().reload_current_scene()
