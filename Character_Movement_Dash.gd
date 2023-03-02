### Pindahin ke player.gd ###

## butuh 6 variable baru dan perubahan pada function player_movement() seperti yang ada dibawah.
## dan butuh input buat detect tombol shift dengan nama "ui_dash" biar script dash ini kerja.
# dashing:boolean default false 
# ableDash:boolean default true
# dashSpeed:int	default 200
# Xdirection:int default 0
# Ydirection:int default 0
# dashInstance: 

var dashing = false
var ableDash = true
var dashSpeed = 15
var Xdirection = 0
var Ydirection = 0
var dashInstance = 50

func player_movement():
	velocity = Vector2()
	if Input.is_action_pressed("down") and dashing == false:
		velocity.y += 1.0
	if Input.is_action_pressed("up") and dashing == false:
		velocity.y -= 1.0
	if Input.is_action_pressed("right") and dashing == false:
		velocity.x += 1.0
	if Input.is_action_pressed("left") and dashing == false:
		velocity.x -= 1.0
	if Input.is_action_just_pressed("ui_dash"):
		player_dash()
	
	return velocity
	

func player_dash(): 
	if ableDash == true:
		# checking player direction before starting dash function
		if Input.is_action_pressed("down"):
			Ydirection = 30
		if Input.is_action_pressed("up"):
			Ydirection = -30
		if Input.is_action_pressed("right"):
			Xdirection = 30
		if Input.is_action_pressed("left"):
			Xdirection = -30
			
		# will dash to current player animation direction if no button w/a/s/d detected
		if not (Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("up") or Input.is_action_pressed("up")):
			if player.flip_h == false:
				Xdirection = 30
			else:
				Xdirection = -30
		
		# can be used to alter animation during dash time 
		# or disabling any function during dashing
		# such as moving player to any direction or attacking.
		# Dashing == true and player direction right/left/up/down = dash animation direction right/left/up/down
		dashing = true
		
		# to prevent dash spamming
		ableDash = false
		
		# start movement dash
		for i in range(dashInstance):
			velocity.x += Xdirection
			velocity.y += Ydirection
			move_and_slide(velocity * dashSpeed)
			# Cooldown after using Dash function (default 0.25 second)
			# rumus 
			# Instance * create_timer(x) = cooldown
			# 0.005 * 50 = 0.5
			yield(get_tree().create_timer(0.005),"timeout")
			
		# returning default value after dash sequence is completed.
		dashing = false
		ableDash = true
		Xdirection = 0
		Ydirection = 0
