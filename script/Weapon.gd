extends Sprite

var velocity = Vector2.ZERO
var isNotAttacking = true

onready var animationPlayer = get_node("../../AnimationPlayer")
onready var animationTree = get_node("../../AnimationTree")
onready var playback = animationTree.get('parameters/playback')
onready var player = get_parent().get_parent().get_node("Character")
#onready var hitbox = get_node("Hitbox")
var attackAnimationIndex = 0
var swordAttackAnimation = ["sword1", "sword2", "sword3"]
var bowAttackAnimation = "bow"
var attackDelay = 0.5
var isNotAttackAnimation = true
var type = "sword"

func _ready():
	PlayerInventory.connect("weaponChanged", self, "updateTexture")

func swordAttack():
	# attack delay timer
	attackDelay = animationPlayer.get_animation(swordAttackAnimation[attackAnimationIndex]).length + 0.05
	isNotAttacking = false
	
#	var attackMoveSpeed = 50.0
#	# Move the player with attacking
#	if player.flip_h == false:
#		velocity.x += 1
#	else:
#		velocity.x -= 1
#	velocity = velocity.normalized() * attackMoveSpeed
	
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

func attackMechanic(attackDirection):
	if isNotAttackAnimation:
#		var mousePos = get_global_mouse_position()
		get_parent().look_at(global_position + attackDirection * 50)
		
		if(attackDirection.x > 0 and player.flip_h):
			player.flip_h = false
		elif(attackDirection.x < 0 and !player.flip_h):
			player.flip_h = true

		match type:
			"bow": 
				bowAttack()
			"sword": 
				swordAttack()

func updateTexture(item):
	texture = item.texture
	flip_h = true

func _on_Hitbox_body_entered(body):
	var swordStatus = JsonData.item_data[PlayerInventory.equips[0][0]]
	if(body.has_method("takesDamage")):
		body.takesDamage((PlayerStatus.strenght + swordStatus['strenght']) * 5, global_position)
