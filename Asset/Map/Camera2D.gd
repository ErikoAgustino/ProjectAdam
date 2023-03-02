extends Camera2D

func _input(event):
	if(event.is_action_pressed("ui_up")):
		self.offset.y -= 10
	elif(event.is_action_pressed("ui_down")):
		self.offset.y += 10
	elif(event.is_action_pressed("ui_left")):
		self.offset.x -= 10
	elif(event.is_action_pressed("ui_right")):
		self.offset.x += 10
