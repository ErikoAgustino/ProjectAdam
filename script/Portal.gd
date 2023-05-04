extends Area2D

signal player_entered

func _on_Portal_body_entered(body):
	if(body.has_method("playerMovement")):
		emit_signal("player_entered")
