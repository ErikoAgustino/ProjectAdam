extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2(60, -500)
var item_name
var initialPosition
var direction = Vector2.ZERO

var player = null
var being_picked_up = false

func _ready():
	item_name = "Slime Potion"
	initialPosition = position
	
func _physics_process(delta):
#	if being_picked_up == false:
#		velocity = velocity.move_toward(Vector2(0, MAX_SPEED), ACCELERATION * delta)
#	else:
#		var direction = global_position.direction_to(player.global_position)
#		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
#
#		var distance = global_position.distance_to(player.global_position)
#		if distance < 4:
#			PlayerInventory.add_item(item_name, 1)
#			queue_free()
#	velocity += Vector2(10, 10)
	if(position.y < initialPosition.y - 50):
		velocity += Vector2(0, 50)
	elif(position.y > initialPosition.y):
		velocity = Vector2.ZERO

	velocity = move_and_slide(velocity)

func pick_up_item(body):
	player = body
	being_picked_up = true

func _on_Area2D_body_entered(body):
	print("OK")
	if(body.has_method("playerMovement")):
#		PlayerInventory.add_item(item_name, 1)
		PlayerStatus.addXP(1)
		queue_free()
