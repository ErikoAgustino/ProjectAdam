extends KinematicBody2D
export var path_to_player := NodePath()
export(int) var lives: int=2
var hp=100
var timer=0
var maxSpeed := 0.0
# Called when the node enters the scene tree for the first time.
var _velocity := Vector2.ZERO
#onready var player_pos = get_parent().get_node("Player").getPosition()
onready var _agent: NavigationAgent2D = $NavigationAgent2D
onready var _player: = get_node(path_to_player)
onready var _timer: Timer = $Timer
func _ready() ->void :
	_agent.set_target_location(_player.global_position)
	_timer.connect("timeout",self,"_update_pathfinding")
func _physics_process(delta: float )-> void:
	timer+=delta
	if _agent.is_navigation_finished():
		return
		
		
	var direction := global_position.direction_to(_agent.get_next_location())
	
	var desired_velocity := direction * maxSpeed
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	
	_velocity = move_and_slide(_velocity)
	if (timer > 0.5):
		jump()
		if (direction.x >0):
			get_node("AnimatedSprite").flip_h = true
		if (direction.x <0): 
			get_node("AnimatedSprite").flip_h = false
	
	

func _update_pathfinding() -> void:
	_agent.set_target_location(_player.global_position)
#func _physics_process(delta):
#	player_pos = get_parent().get_node("Player").getPosition()
#	var direction = (player_pos - position).normalized()	
#	move_and_slide(direction*SPEED)
#	timer += delta
#	if (timer > 0.5):
#		jump()
#
#
#
func jump():
	maxSpeed = 120.0
	get_node("AnimatedSprite").scale = Vector2(1.1, 1.1)
	if (timer>1.2):
		get_node("AnimatedSprite").scale = Vector2(1, 1)
		maxSpeed = 0.0
		timer = 0
		pass

#func jump():
#		get_node("CollisionShape2D").disabled = true
#		if (timer>6):
#			get_node("Sprite").hide()
#		if (timer > 8):
#			get_node("CollisionShape2D").disabled = false
#			get_node("Sprite").show()
#			get_node("Sprite").scale = Vector2(1, 1)
#			timer = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	lives-=1
	if (lives==0):
		var scene = load("Slime.tscn")
		var slime = scene.instance()
		get_parent().remove_child(self)


func _on_Slime_lives():
	pass # Replace with function body.

