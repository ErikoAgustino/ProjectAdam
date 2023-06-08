extends Node2D

var maxtime = 2
var positionStart = Vector2(0, 0)

func _ready():
	var timer = Timer.new()
	timer.wait_time = maxtime
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout",self,"on_timeout")

func on_timeout():
	self.queue_free()

	

