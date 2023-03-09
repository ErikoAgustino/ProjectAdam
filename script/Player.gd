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
onready var hitbox = $Hitbox
var attackAnimationIndex = 0
var attackAnimationName = ["sword1", "sword2", "sword3"]
var attackDelay = 0.5
var isNotAttackAnimation = true

onready var dash = get_node("Dash")

func attack_mechanic():
	# If attack button clicked
	if Input.is_action_just_pressed("attack") && isNotAttackAnimation:
		attackDelay = $AnimationPlayer.get_animation(attackAnimationName[attackAnimationIndex]).length + 0.5
		isNotAttacking = false
		# Move the player with attacking
		if player.flip_h == false:
			velocity.x += 1
		else:
			velocity.x -= 1
		velocity = velocity.normalized() * attackMoveSpeed
		# Check if animation frame is over
		if attackAnimationIndex == attackAnimationName.size():
			attackAnimationIndex = 0
		# Start timer and play the attack animation
		playback.travel(attackAnimationName[attackAnimationIndex])
		print(attackAnimationName[attackAnimationIndex])
		isNotAttackAnimation = false
		yield(get_tree().create_timer($AnimationPlayer.get_animation(attackAnimationName[attackAnimationIndex]).length - 0.1), "timeout")
		velocity = Vector2.ZERO
		attackAnimationIndex += 1
		isNotAttackAnimation = true
		#yield(get_tree().create_timer(0.5), "timeout")
		print(attackAnimationIndex)
		if attackAnimationIndex > 2:
			attackAnimationIndex = 0

func player_movement():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("down"):
		velocity.y += 1.0
	if Input.is_action_pressed("up"):
		velocity.y -= 1.0
	if Input.is_action_pressed("right"):
		velocity.x += 1.0
		player.flip_h = false
#		hitbox.flip_h = false
	if Input.is_action_pressed("left"):
		velocity.x -= 1.0
		player.flip_h = true
#		hitbox.flip_h = false
		
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
	if(isNotAttacking):
		attackDelay = 0.8
		player_movement()
	else:
		attackDelay -= delta
		if(attackDelay < 0):
			attackAnimationIndex = 0
			isNotAttacking = true

	attack_mechanic()
	velocity = move_and_slide(velocity)
