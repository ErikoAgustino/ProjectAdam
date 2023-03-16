extends Sprite

var velocity = Vector2.ZERO
var isNotAttacking = true

onready var animationPlayer = get_node("../../AnimationPlayer")
onready var animationTree = get_node("../../AnimationTree")
onready var playback = animationTree.get('parameters/playback')
onready var player = get_parent().get_parent().get_node("Character")
onready var hitbox = get_node("WeaponContainer/Weapon/Hitbox")
var attackAnimationIndex = 0
var swordAttackAnimation = ["sword1", "sword2", "sword3"]
var bowAttackAnimation = "bow"
var attackDelay = 0.5
var isNotAttackAnimation = true
var type = "sword"

func swordAttack():
	# attack delay timer
	attackDelay = animationPlayer.get_animation(swordAttackAnimation[attackAnimationIndex]).length + 0.05
	isNotAttacking = false
	var attackMoveSpeed = 50.0
	# Move the player with attacking
	if player.flip_h == false:
		velocity.x += 1
	else:
		velocity.x -= 1
	velocity = velocity.normalized() * attackMoveSpeed
	# Check if animation frame is over
	if attackAnimationIndex == swordAttackAnimation.size():
		attackAnimationIndex = 0
	# Start timer and play the attack animation
	playback.travel(swordAttackAnimation[attackAnimationIndex])
	isNotAttackAnimation = false
	
	yield(get_tree().create_timer(animationPlayer.get_animation(swordAttackAnimation[attackAnimationIndex]).length - 0.1), "timeout")
	velocity = Vector2.ZERO
	attackAnimationIndex += 1
	isNotAttackAnimation = true
	#yield(get_tree().create_timer(0.5), "timeout")
#	print(attackAnimationIndex)
	if attackAnimationIndex > 2:
		attackAnimationIndex = 0
			
func bowAttack():
	velocity = Vector2.ZERO
	isNotAttacking = false
	playback.travel("bow")
	isNotAttackAnimation = true

func attackMechanic(temp):
	if Input.is_action_just_pressed("attack") && isNotAttackAnimation:
#		var mousePos = get_global_mouse_position()
		get_parent().look_at(temp)
		match type:
			"bow": 
				bowAttack()
			"sword": 
				swordAttack()

func _on_Hitbox_body_entered(body):
	#print(body)
	pass
