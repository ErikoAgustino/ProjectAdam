extends KinematicBody2D

# Declare member variables here. Examples:
export (float) var moveSpeed = 200.0
export (float) var dashSpeed = 1000
export (float) var attackMoveSpeed = 50.0
export (float) var dashDuration = 0.2
var velocity = Vector2.ZERO
onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get('parameters/playback')
onready var player = $Character
onready var hitbox = get_node("WeaponContainer/Weapon/Hitbox")


onready var dash = get_node("Dash")
onready var weaponContainer = get_node("WeaponContainer")
onready var weapon = weaponContainer.get_node("Weapon")

func playerMovement():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("down"):
		velocity.y += 1.0
	if Input.is_action_pressed("up"):
		velocity.y -= 1.0
	if Input.is_action_pressed("right"):
		velocity.x += 1.0
		player.flip_h = false
#		hitbox.flip_h(false)
	if Input.is_action_pressed("left"):
		velocity.x -= 1.0
		player.flip_h = true
#		hitbox.flip_h(true)
		
	# Move and animation
	if velocity == Vector2.ZERO:
		playback.travel("idle")
	else:
		playback.travel("walk")	
		#dash
		if(Input.is_action_just_pressed("dash") && !dash.isDashing() && dash.canDash):
			dash.startDash(dashDuration, player)
			playback.travel("dash")
	
	var speed = dashSpeed if dash.isDashing() else moveSpeed
	velocity = velocity.normalized() * speed	

		
func _physics_process(delta):
	if(weapon.isNotAttacking):
		weapon.attackDelay = 0.8
		playerMovement()
	else:
		weapon.attackDelay -= delta
		if(weapon.attackDelay < 0):
			weapon.attackAnimationIndex = 0
			weapon.isNotAttacking = true
	
	weapon.attackMechanic()
	if !weapon.isNotAttackAnimation:
		velocity = velocity.normalized() * attackMoveSpeed
	velocity = move_and_slide(velocity)
