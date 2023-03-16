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

onready var progressBar = $ProgressBar
var status = ""
var damage = 1
var positionStart = Vector2(0, 0)

func _ready() ->void :
	progressBar.value = hp
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
		

func knockback(forceValue):
	_velocity -= forceValue
	
func _on_Slime_lives():
	pass # Replace with function body.

func kenaDMG(dmg,pos_,speed=500):
	progressBar.value -= dmg
	var forceValue = Vector2(0,0)
	if speed > 750:
		speed = 750
		
	if pos_.x - self.position.x >= 0: 
		forceValue.x = speed # knockback kekanan
	else:
		forceValue.x = -speed # knockback kekiri
		
	if pos_.y - self.position.y >= 0:
		forceValue.y = speed # knockback keatas
	else: 
		forceValue.y = -speed # knockback kebawah
	knockback(forceValue)
	if progressBar.value <= 0:
		self.queue_free()
	
func iniLawan():
	pass # cuman treshold biar player tau ini lawan.
	
func getDamage():
	return damage
func getPosition():
	return self.position
