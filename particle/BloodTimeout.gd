extends Node2D

var maxtime = 2
var positionStart = Vector2(0, 0)
#var defaultColor = Color(255, 255, 255, 255)
onready var particles = $Particles2D

func _ready():
#	particles.process_material.set("color", defaultColor)
	var timer = Timer.new()
	timer.wait_time = maxtime
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout",self,"on_timeout")

func on_timeout():
	self.queue_free()

func setColor(color: Color):
	particles.process_material.set("color", color)
