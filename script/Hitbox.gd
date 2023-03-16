extends Area2D

onready var hitArea = get_node("CollisionShape2D")
var positionStart = Vector2(0, 0)
var damage = 40

func flip_h(bol):
	var x = 20 if !bol else -20
	hitArea.position.x = x
	positionStart = hitArea.position
	


func _on_Hitbox_body_entered(body):
	print("bruh")
	if body.has_method("iniPlayer"):
		pass
	else:
		if(body.has_method("kenaDMG")):
			body.kenaDMG(damage,positionStart)
