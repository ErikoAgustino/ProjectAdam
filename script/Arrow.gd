extends KinematicBody2D

var velocity = Vector2(0, 0)
var speed = 0
var maxtime = 1.2
var invistime = 0.2
var chargeType = ""
var damage = 20
var positionStart = Vector2(0, 0)

var a = load("res://particle/BowEffectStrong.tscn")
var b = a.instance()

func _ready():
	var timer = Timer.new()
	var invistimer = Timer.new()
	$CollisionShape2D.disabled = true
	timer.wait_time = maxtime
	invistimer.wait_time = invistime
	timer.autostart = true
	invistimer.autostart = true
	add_child(timer)
	timer.connect("timeout",self,"on_timeout")
	timer.connect("timeout",self,"on_timeout_invis")
	print(chargeType)
	if(chargeType == "weak"):
		speed = 200
		damage = 1
	if(chargeType == "medium"):
		speed = 400
		damage = 60
	if(chargeType == "strong"):
		speed = 1000
		damage = 100
	positionStart = self.position
	
	
func on_timeout():
	self.queue_free()

func on_timeout_invis():
	$CollisionShape2D.disabled = false
	
func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	b = a.instance()
	b.position = global_position
	get_parent().add_child(b)
	
func _on_Area2D_body_entered(body):
	if(body.has_method("takesDamage")):
		body.takesDamage(damage, global_position)
	self.queue_free()
