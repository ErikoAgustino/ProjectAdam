extends "res://script/enemy.gd"


func _ready() ->void :
	_agent.set_target_location(_player.global_position)
	_timer.connect("timeout",self,"_update_pathfinding")
func _physics_process(delta: float )-> void:
	timer+=delta
	if _agent.is_navigation_finished():
		return
		
		
	var direction := global_position.direction_to(_agent.get_next_location())
	
	var desired_velocity := direction * maxSpeed
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	
	_velocity = move_and_slide(_velocity)
	if (timer > 0.5):
		jump()
		if (direction.x >0):
			get_node("AnimatedSprite").flip_h = true
		if (direction.x <0): 
			get_node("AnimatedSprite").flip_h = false
	
	

func _update_pathfinding() -> void:
	_agent.set_target_location(_player.global_position)
#func _physics_process(delta):
#	player_pos = get_parent().get_node("Player").getPosition()
#	var direction = (player_pos - position).normalized()	
#	move_and_slide(direction*SPEED)
#	timer += delta
#	if (timer > 0.5):
#		jump()
#
#
#
func jump():
	maxSpeed = 120.0
	get_node("AnimatedSprite").scale = Vector2(1.1, 1.1)
	if (timer>1.2):
		get_node("AnimatedSprite").scale = Vector2(1, 1)
		maxSpeed = 0.0
		timer = 0
		pass

#func jump():
#		get_node("CollisionShape2D").disabled = true
#		if (timer>6):
#			get_node("Sprite").hide()
#		if (timer > 8):
#			get_node("CollisionShape2D").disabled = false
#			get_node("Sprite").show()
#			get_node("Sprite").scale = Vector2(1, 1)
#			timer = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	hp-= _player.getAttack()
	if(hp<=0):
		var live=self.lives

		var scene = load("res://scene/enemy/Slime.tscn")
		var slime = scene.instance()
		slime.path_to_player = self.path_to_player
		slime.lives=live-1
		slime.position = self.get_position()
		slime.hp=100
		get_parent().add_child(slime)
		print("spawn")
		var slime2 = scene.instance()
		slime2.path_to_player = self.path_to_player
		slime2.lives=live-1
		slime2.hp=100
		slime2.position = self.get_position() + Vector2(100.0,100.0)
		get_parent().add_child(slime2)
		print("spawn2")
		get_parent().remove_child(self)
		queue_free()
		print ("mati")
	else:
		spawn_damage(_player.getAttack())
		print ("kena")
		
	if (lives<=0):
		get_parent().remove_child(self)
		queue_free()
		
