extends Area2D

onready var hitArea = get_node("CollisionShape2D")

func flip_h(bol):
	var x = 20 if !bol else -20
	hitArea.position.x = x


func _on_Hitbox_body_entered(body):
	print (body)
