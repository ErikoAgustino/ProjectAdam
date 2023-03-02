extends KinematicBody2D

var velocity = Vector2(0, 0)
var speed = 0
var maxtime = 1.2
var invistime = 0.2
var chargeType = ""

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
	if(chargeType == "medium"):
		speed = 400
	if(chargeType == "strong"):
		speed = 1000
	
	
func on_timeout():
	self.queue_free()

func on_timeout_invis():
	$CollisionShape2D.disabled = false
	
func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	
