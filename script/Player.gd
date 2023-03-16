extends KinematicBody2D

# Declare member variables here. Examples:
export (float) var moveSpeed = 200.0
export (float) var dashSpeed = 1000
export (float) var attackMoveSpeed = 50.0
export (float) var dashDuration = 0.2
var velocity = Vector2.ZERO
var isNotAttacking = true
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get('parameters/playback')
onready var player = $Character
onready var attackTimer = $AttackTimer
onready var hitbox = get_node("WeaponContainer/Weapon/Hitbox")
var attackAnimationIndex = 0
#var attackAnimationName = 
var swordAttackAnimation = ["sword1", "sword2", "sword3"]
var bowAttackAnimation = "bow"
var attackDelay = 0.5
var isNotAttackAnimation = true
var type = "sword"


onready var dash = get_node("Dash")
onready var weaponContainer = get_node("WeaponContainer")
onready var weapon = weaponContainer.get_node("Weapon")

#func swordAttack():
#	# attack delay timer
#	attackDelay = $AnimationPlayer.get_animation(swordAttackAnimation[attackAnimationIndex]).length + 0.5
#	isNotAttacking = false
#	# Move the player with attacking
#	if player.flip_h == false:
#		velocity.x += 1
#	else:
#		velocity.x -= 1
#	velocity = velocity.normalized() * attackMoveSpeed
#	# Check if animation frame is over
#	if attackAnimationIndex == swordAttackAnimation.size():
#		attackAnimationIndex = 0
#	# Start timer and play the attack animation
#	playback.travel(swordAttackAnimation[attackAnimationIndex])
#	isNotAttackAnimation = false
#	yield(get_tree().create_timer($AnimationPlayer.get_animation(swordAttackAnimation[attackAnimationIndex]).length - 0.1), "timeout")
#	velocity = Vector2.ZERO
#	attackAnimationIndex += 1
#	isNotAttackAnimation = true
#	#yield(get_tree().create_timer(0.5), "timeout")
#	print(attackAnimationIndex)
#	if attackAnimationIndex > 2:
#		attackAnimationIndex = 0
#
#func bowAttack():
#	velocity = Vector2.ZERO
#	isNotAttacking = false
#	playback.travel("bow")
#	isNotAttackAnimation = true
#
#func attackMechanic():
#	if Input.is_action_just_pressed("attack") && isNotAttackAnimation:
#		var mousePos = get_global_mouse_position()
#		weaponContainer.look_at(mousePos)
#		match type:
#			"bow": 
#				bowAttack()
#			"sword": 
#				swordAttack()
			
var attackDirection = Vector2()

func attackDirection():
	attackDirection = Vector2()
	if Input.is_action_pressed("down"):
		attackDirection.y = 1.0
	if Input.is_action_pressed("up"):
		attackDirection.y = -1.0
	if Input.is_action_pressed("right"):
		attackDirection.x = 1.0
	if Input.is_action_pressed("left"):
		attackDirection.x = -1.0

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
		weapon.attackDelay = 0.3
		playerMovement()
	else:
		weapon.attackDelay -= delta
		if(weapon.attackDelay < 0):
			weapon.attackAnimationIndex = 0
			weapon.isNotAttacking = true
	attackDirection()
	weapon.attackMechanic(position + (attackDirection.normalized() * 50))
#	playerMovement()
	if !weapon.isNotAttackAnimation:
		velocity = velocity.normalized() * attackMoveSpeed
	velocity = move_and_slide(velocity)

