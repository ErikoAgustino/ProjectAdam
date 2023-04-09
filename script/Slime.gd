extends "res://script/Enemy.gd"

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
	
	_velocity = move_and_slide(_velocity)

	if (timer > 0.5):
		jump()
		if (direction.x > 0):
			get_node("AnimatedSprite").flip_h = true
		if (direction.x < 0): 
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
	hp-= 50
	if(hp<=0):
		var live = self.lives

		var scene = load("res://scene/enemy/Slime.tscn")
		var slime = scene.instance()
		slime.path_to_player = self.path_to_player
		slime.lives = live - 1
		slime.position = self.get_position()
		slime.hp=100
		get_parent().add_child(slime)
		
		var slime2 = scene.instance()
		slime2.path_to_player = self.path_to_player
		slime2.lives=live-1
		slime2.hp=100
		slime2.position = self.get_position() + Vector2(100.0,100.0)
		get_parent().add_child(slime2)
		
		get_parent().remove_child(self)
		queue_free()	
	else:
		spawn_damage(dmg)
		knockback(attackPosition)
		
	if (lives<=0):
		get_parent().remove_child(self)
		queue_free()

func _on_Area2D_body_entered(body):
	if(body.has_method("takesDamage")):
		body.takesDamage(50, global_position)
