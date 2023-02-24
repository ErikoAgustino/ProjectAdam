extends KinematicBody2D


# Declare member variables here. Examples:
var speed = 200.0
var velocity = Vector2.ZERO
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get('parameters/playback')
onready var player = $Sprite

func player_movement():
	velocity = Vector2()
	if Input.is_action_pressed("down"):
		velocity.y += 1.0
	if Input.is_action_pressed("up"):
		velocity.y -= 1.0
	if Input.is_action_pressed("right"):
		velocity.x += 1.0
	if Input.is_action_pressed("left"):
		velocity.x -= 1.0
	return velocity

func player_animation():
	playback.travel("run")
	if Input.is_action_pressed("right"):
		player.flip_h = false
	if Input.is_action_pressed("left"):
		player.flip_h = true
		
func _physics_process(delta):
	# Move and animation
	velocity = player_movement().normalized()
	if velocity == Vector2.ZERO:
		playback.travel("idle")
	else:
		player_animation()
		move_and_slide(velocity * speed)
