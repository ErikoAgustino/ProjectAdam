extends "res://script/enemy.gd"
var State = "Idle"
const DropItem = preload("res://scene/ui/ItemDrop.tscn")
var follow_player = false
onready var ANI = get_node("AnimationPlayer")
func _ready() ->void :
	_agent.set_target_location(_player.global_position)
	_timer.connect("timeout",self,"_update_pathfinding")
func _physics_process(delta: float )-> void:
	
#	print(State)
	if ANI.get_current_animation() != State:
		ANI.play(State)
	if (follow_player):
		timer+=delta
#	print(timer)
	if _agent.is_navigation_finished():
		return
		
		
	var direction := global_position.direction_to(_agent.get_next_location())
	
	var desired_velocity := direction * maxSpeed
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	if (follow_player):
		_velocity = move_and_slide(_velocity)
	if (timer > 0.5):
		
		if (timer>2):
			State = "Jump"
		if (timer>2.9):
			get_node("Collisionbody").disabled = true
			get_node("Area2D/Collisiondamage").disabled = true
			
			
			State = "hilang"
			maxSpeed=200
			
		if (timer > 5):
			State = "Land"
			maxSpeed=0
			get_node("Collisionbody").disabled = false
			get_node("Area2D/Collisiondamage").disabled = false
			
		if (timer > 5.6):
			State ="Walk"
			timer = 0
			maxSpeed=100
			

	
	

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



#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass
	#hp-= 50
	#if(hp<=0):
	#	duplicate_slime()
#		var live=self.lives
#
#		var scene = load("res://scene/enemy/Slime.tscn")
#		var slime = scene.instance()
#		slime.path_to_player = self.path_to_player
#		slime.lives=live-1
#		slime.position = self.get_position()
#		slime.hp=100
#		get_parent().add_child(slime)
#		print("spawn")
#		var slime2 = scene.instance()
#		slime2.path_to_player = self.path_to_player
#		slime2.lives=live-1
#		slime2.hp=100
#		slime2.position = self.get_position() + Vector2(100.0,100.0)
#		get_parent().add_child(slime2)
#		print("spawn2")
#		get_parent().remove_child(self)
	#	queue_free()
	#	print ("mati")
	#else:
		
	#	print ("kena")
	#spawn_damage(5000)
		
	#if (lives<=0):
	#	get_parent().remove_child(self)
	#	queue_free()
	#	

func Spawn_slime(direction: Vector2) -> void:
	var slime: KinematicBody2D = load("res://scene/enemy/slimeBoss.tscn").instance()
	slime.position=position
	slime.scale=scale/2
	slime.hp = max_hp/2.0
	slime.max_hp = max_hp/2.0
	get_parent().add_child(slime)
func duplicate_slime()-> void:
	if scale > Vector2(1,1):
		var impulse_direction: Vector2 = Vector2.RIGHT.rotated(rand_range(0,2*PI))
		Spawn_slime(impulse_direction)
		Spawn_slime(impulse_direction*-1)
	
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
		
		get_parent().remove_child(self)
		queue_free()	
	else:
		knockback(attackPosition)
		
	if (lives<=0):
		get_parent().remove_child(self)
		queue_free()

#func _on_detectPlayer_body_exited(body):
#	if body == _player:
#		follow_player = false

func _on_detectPlayer_body_entered(body):
	if body == _player:
		follow_player = true


func _on_Area2D_body_entered(body):
		if(body.has_method("takesDamage")):
			body.takesDamage(10, global_position)


func _on_Portal_tree_entered():
	pass # Replace with function body.
