extends KinematicBody2D


# Declare member variables here. Examples:
var moveSpeed = 200.0
var dashSpeed = 1000
var attackMoveSpeed = 8.0
var dashDuration = 0.2
var velocity = Vector2.ZERO
var isNotAttacking = true
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get('parameters/playback')
onready var player = $Sprite
onready var attackTimer = $AttackTimer
onready var hitbox = $Hitbox
var attackAnimationName = ["sword1", "sword2", "sword3"]
var attackAnimationIndex = 0

onready var dash = get_node("Dash")

func attack_mechanic():
	# If attack button clicked
	if Input.is_action_just_pressed("attack"):
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
		attackTimer.start()
		playback.travel(attackAnimationName[attackAnimationIndex])
		# Check if user clicked the button before attack duration are over
		# If not, change the next animation
		if attackTimer.time_left > 0:
			attackAnimationIndex += 1
		# If it's over but the user didn't click the button, restart the animation
		else:
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
		hitbox.flip_h(false)
	if Input.is_action_pressed("left"):
		velocity.x -= 1.0
		player.flip_h = true
		hitbox.flip_h(true)
		
	# Move and animation
	if velocity == Vector2.ZERO:
		playback.travel("idle")
	else:
		playback.travel("run")	
		#dash
		if(Input.is_action_just_pressed("dash") && !dash.isDashing() && dash.canDash):
			dash.startDash(dashDuration, player)
			playback.travel("dash")
	
	var speed = dashSpeed if dash.isDashing() else moveSpeed	
	move_and_slide(velocity * speed)
	return velocity

		
func _physics_process(delta):
	if(isNotAttacking):
		player_movement()
	attack_mechanic()

func _on_AttackTimer_timeout():
	isNotAttacking = true
func getPosition():
	return position
