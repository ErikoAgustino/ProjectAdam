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
#onready var attackTimer = $AttackTimer
onready var hitbox = get_node("WeaponContainer/Weapon/Hitbox")
var attackAnimationIndex = 0
#var attackAnimationName = 
var swordAttackAnimation = ["sword1", "sword2", "sword3"]
var bowAttackAnimation = "bow"
var attackDelay = 0.5
var isNotAttackAnimation = true
var type = "sword"

const arrowPath = preload('res://scene/character/Arrow.tscn')
var timerCharge = 2

var timer = Timer.new()
var invincibleTimer = Timer.new()
var stunnedTimer = Timer.new()
var rangeOnHold = false
var maxCharge = false
var timerRemoved = false
onready var progressBar = $ProgressBar
onready var lineIndicator = $bow/Position2D/Icon
onready var health = $Health
var damage = 12
var invincibleTimerTime = 1.5
var invincibleFrame = false
var isStunned = false
var isKnockingBack = false

onready var dash = get_node("Dash")
onready var weaponContainer = get_node("WeaponContainer")
onready var weapon = weaponContainer.get_node("Weapon")

var attackDirection = Vector2()

##Variable baru
var flashBlinking = 0.0;
var blinking = false;

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
	velocity.x = Input.get_axis("left", "right")
	velocity.y = Input.get_axis("up", "down")

	# Move and animation
	if(weapon.isNotAttacking):
		if Input.is_action_pressed("right"):
			player.flip_h = false
		if Input.is_action_pressed("left"):
			player.flip_h = true
		
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

func rangeAttack():
		## start charging bow with "z" max = 2 seconds
	if Input.is_action_just_pressed("range_attack"):
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
	if Input.is_action_just_released("range_attack"):
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
		
	if invincibleTimer.time_left <= 0.1 and invincibleFrame == true:
		invincibleFrame = false
		invincibleTimer.stop()
		remove_child(invincibleTimer)
		##### new code
		#### disabling interaction between player and enemy
		set_collision_layer(1)
		set_collision_mask(514)
		blinking = false;
		######
		print("invicibility habis")

func shoot(chargeType):
	var arrow = arrowPath.instance()
	arrow.position = $bow/Position2D.global_position
	arrow.chargeType = chargeType
	arrow.velocity = get_global_mouse_position() - arrow.position
	get_parent().add_child(arrow)
	
func knockback(attackPosition):
	velocity = ((position - attackPosition).normalized()) * 500
	isKnockingBack = true
	yield(get_tree().create_timer(0.2), "timeout")
	isKnockingBack = false
	#sample
#	$Tween.interpolate_property(self, "position", position, position + velocity, 0.2, Tween.TRANS_LINEAR)
#	$Tween.start()
	
func takesDamage(dmg, attackPosition):
	PlayerStatus.changeHealth(PlayerStatus.currentHealth - dmg)
	
	# Camera2D.shake(duration, frequency, amplitude, priority)
	$Camera/Camera2D.shake(0.2, 15, 20, 0)
	
	if(PlayerStatus.currentHealth < 1):
		get_tree().change_scene("res://scene/level/EndScene.tscn")
	knockback(attackPosition)
	var a = load("res://particle/BloodRedParticle.tscn")
	var b = a.instance()
	b.position = global_position
	get_parent().add_child(b)
	invincible()
	
###### new code
##### added invicible() function
func invincible():
	invincibleFrame = true
	invincibleTimer = Timer.new()
	set_collision_layer(0)
	set_collision_mask(512)
	blinking = true 
	
	#$CollisionShape2D.set_deferred("disabled", true)
	#$WeaponContainer/Weapon/Hitbox.set_deferred("monitoring", false)
	invincibleTimer.wait_time = invincibleTimerTime
	invincibleTimer.autostart = true
	add_child(invincibleTimer)
	stunned(0.6)
######

func stunned(duration):
	duration += 0.2
	stunnedTimer = Timer.new()
	stunnedTimer.wait_time = duration
	stunnedTimer.autostart = true
	add_child(stunnedTimer)
	isStunned = true	

func updateAttackDirectionPosition():
	attackDirection.x = Input.get_axis("atkLeft", "atkRight")
	attackDirection.y = Input.get_axis("atkUp", "atkDown")

func skillAttack():
	if(Input.is_action_just_pressed("skill1")):
		shoot("strong")

func _physics_process(delta):
	if(!isKnockingBack):
		if(weapon.isNotAttacking):
			weapon.attackDelay = 0.3
		else:
			weapon.attackDelay -= delta
			if(weapon.attackDelay < 0):
				weapon.attackAnimationIndex = 0
				weapon.isNotAttacking = true
		playerMovement()
		$bow.look_at(get_global_mouse_position())
		rangeAttack()
		skillAttack()
	#	attackDirection()
		updateAttackDirectionPosition()
		if(attackDirection.x > 0 or attackDirection.y > 0 or attackDirection.x < 0 or attackDirection.y < 0):
			weapon.attackMechanic(attackDirection.normalized())
#	playerMovement()
#	if !weapon.isNotAttackAnimation:
#		velocity = velocity.normalized() * attackMoveSpeed
	
	##### new code 
	#### added blinking effect
	if(blinking == true):
		flashBlinking += 0.1
		if(flashBlinking >= 0.6):
			flashBlinking = 0
		$Character.material.set_shader_param("flash_modifier", flashBlinking)
	else: 
		flashBlinking = 0.0
		$Character.material.set_shader_param("flash_modifier", 0.0)
	######
		
	velocity = move_and_slide(velocity)

#func _on_Hitbox_body_entered(body):
#	if(body.has_method("isEnemy")):
#		kenaDMG(50, body.position)

