extends KinematicBody2D
export var path_to_player := NodePath()
export(int) var lives: int = 2
export(int) var hp: int = 100
export(int) var max_hp: int=100
var timer=0
var maxSpeed := 100

var _velocity := Vector2.ZERO
onready var _agent: NavigationAgent2D = $NavigationAgent2D
onready var _player: = get_node(path_to_player)
onready var _timer: Timer = $Timer
const damage_indc = preload("res://scene/ui/DamageIndicator.tscn")

func _ready() ->void :
	_agent.set_target_location(_player.global_position)
	_timer.connect("timeout",self,"_update_pathfinding")


func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect

func spawn_damage (damage:int):
	var indicator = spawn_effect(damage_indc)
	if indicator :
		indicator.label.text = str(damage)

func isEnemy():
	pass
