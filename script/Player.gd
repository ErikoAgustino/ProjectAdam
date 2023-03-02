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
const arrowPath = preload('res://scene/character/Arrow.tscn')
var attackAnimationName = ["sword1", "sword2", "sword3"]
var attackAnimationIndex = 0
var timerCharge = 2
onready var dash = get_node("Dash")

var timer = Timer.new()
var rangeOnHold = false
var maxCharge = false
var timerRemoved = false
onready var progressBar = $ProgressBar
onready var lineIndicator = $bow/Position2D/Icon

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

	## start charging bow with "z" max = 2 seconds
	if Input.is_action_just_pressed("ranged_attack"):
		# starting new timer
		timerRemoved = false
		timer = Timer.new()
		timer.wait_time = timerCharge
		timer.autostart = true
		add_child(timer)
		rangeOnHold = true
		# showing an indicator using line from "Icon" node
		lineIndicator.visible = true
		progressBar.visible = true
		# lowering movement speed while charging bow
		moveSpeed -= 100
		
	## charge power meter
	progressBar.value = timerCharge - timer.time_left
	
	## charge max
	if timer.time_left < 0.1 and rangeOnHold == true: 
		maxCharge = true
		if(timerRemoved == false):
			print("full charge")
			timer.stop()
			remove_child(timer)
			timerRemoved = true
		
		
	## release bow 
	if Input.is_action_just_released("ranged_attack"):
		var time = timer.time_left
		print(time)
		if(timerRemoved == false):
			timer.stop()
			remove_child(timer)
		rangeOnHold = false
		
		# charge power level
		if time >= 1.1:
			shoot("weak")
		if time > 0 and time < 1.1:
			shoot("medium")
		if maxCharge == true:
			maxCharge = false
			shoot("strong")
		
		#return to default value
		moveSpeed += 100
		progressBar.value = 0
		progressBar.visible = false
		lineIndicator.visible = false
		
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
	$bow.look_at(get_viewport().get_mouse_position())
	if(isNotAttacking):
		player_movement()
	attack_mechanic()

func _on_AttackTimer_timeout():
	isNotAttacking = true

### creating new arrow projectile (need a string variable type)
func shoot(chargeType):
	var arrow = arrowPath.instance()
	arrow.position = $bow/Position2D.global_position
	arrow.chargeType = chargeType
	arrow.velocity = get_global_mouse_position() - arrow.position
	get_parent().add_child(arrow)
