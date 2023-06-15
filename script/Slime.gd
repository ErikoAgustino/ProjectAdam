extends "res://script/enemy.gd"
var follow_player = false
const DropItem = preload("res://scene/ui/ItemDrop.tscn")

func _ready() ->void :
	_agent.set_target_location(_player.global_position)
#	_timer.connect("timeout",self,"_update_pathfinding")
	
func _physics_process(delta: float )-> void:
	timer += delta
	if _agent.is_navigation_finished():
		return

	var direction := global_position.direction_to(_agent.get_next_location())
	
	var desired_velocity := direction * maxSpeed
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	


	if (follow_player):
		_velocity = move_and_slide(_velocity)
		if (direction.x >0):
			get_node("AnimatedSprite").flip_h = true	
		if (direction.x <0): 
			get_node("AnimatedSprite").flip_h = false
	
func _update_pathfinding() -> void:
	_agent.set_target_location(_player.global_position)

func jump():
	maxSpeed = 120.0
	get_node("AnimatedSprite").scale = Vector2(1.1, 1.1)
	if (timer>1.2):
		get_node("AnimatedSprite").scale = Vector2(1, 1)
		maxSpeed = 0.0
		timer = 0
		pass

func knockback(attackPosition):
	_velocity = ((position - attackPosition).normalized()) * 500
	
func takesDamage(dmg, attackPosition):
	hp-= dmg
	spawn_damage(dmg)
	if(hp<=0):
		var dropItem = DropItem.instance()
		dropItem.item_name = "Slime Potion"
		dropItem.position = global_position
		get_parent().add_child(dropItem)
		var a = load("res://particle/BloodBlackParticleBig.tscn")
		var b = a.instance()
		b.position = global_position
		get_parent().add_child(b)
		get_parent().remove_child(self)
	
		queue_free()
	else:
		knockback(attackPosition)
		
		var a = load("res://particle/BloodBlackParticle.tscn")
		var b = a.instance()
		b.position = global_position
		get_parent().add_child(b)
		
	if (lives<=0):
		get_parent().remove_child(self)
		queue_free()


func _on_Area2D_body_entered(body):
	if(body.has_method("takesDamage")):
		body.takesDamage(4, global_position)
		
func _on_detectPlayer_body_entered(body):
	if body == _player:
		setFollowPlayer(true)

func setFollowPlayer(bol):
	follow_player = bol
