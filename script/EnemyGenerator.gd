extends StaticBody2D

const Slime = preload("res://scene/enemy/Slime2.tscn")
const damage_indc = preload("res://scene/ui/DamageIndicator.tscn")

var timer = 0
var hp = 150

onready var healthBar = $HealthBar

func _ready():
	hp += 100 * (PlayerStatus.level * 0.1)
	healthBar.max_value = hp
	healthBar.value = hp

func _process(delta):
	timer += delta
	if(timer > 3):
		timer = 0
		generateSlime()

func generateSlime():
	var slime = Slime.instance()
	slime.global_position = global_position
#	slime.setFollowPlayer(true)
	slime.path_to_player = NodePath("../Player")
	get_parent().add_child(slime)

func takesDamage(dmg, attackPosition):
	hp -= dmg
	healthBar.value = hp
	spawn_damage(dmg)
	if(hp < 1):
		var a = load("res://particle/BloodRedParticle.tscn")
		var b = a.instance()
		b.position = global_position
		get_parent().add_child(b)
		get_parent().remove_child(self)
		queue_free()

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
