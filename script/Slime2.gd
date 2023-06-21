extends KinematicBody2D

export var path_to_player := NodePath()

const DropItem = preload("res://scene/ui/ItemDrop.tscn")
const damage_indc = preload("res://scene/ui/DamageIndicator.tscn")

onready var player = get_node(path_to_player)
onready var healthBar = get_node("HealthBar")
var direction = Vector2.ZERO
var speed = 4000
var hp = 100

var isKnockingBack = false

func _ready():
	hp += 100 * (PlayerStatus.level * 0.2)
	healthBar.max_value = hp
	healthBar.value = hp

func updateDirection(followPosition):
	direction = followPosition - position

func _physics_process(delta):
	if(!isKnockingBack):
		updateDirection(player.global_position)
	
		if(direction.x > 0):
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		move_and_slide(direction.normalized() * delta * speed)
	else:
		move_and_slide(direction.normalized() * delta * 6000)
	
func _on_Area2D_body_entered(body):
	if(body.has_method("takesDamage")):
		body.takesDamage(4, global_position)

	
func takesDamage(dmg, attackPosition):
	hp-= dmg
	healthBar.value = hp
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
		

func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect

func spawn_damage (damage:int):
	var indicator = spawn_effect(damage_indc)
	if indicator :
		indicator.label.text = str(damage)

func knockback(attackPosition):
	direction = ((position - attackPosition).normalized()) * 500
	isKnockingBack = true
	$Timer.start(0.5)

func _on_Timer_timeout():
	isKnockingBack = false
