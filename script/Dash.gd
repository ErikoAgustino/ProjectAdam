extends Node2D

const ghostScene = preload("res://scene/character/DashGhost.tscn")

onready var durationTimer = get_node("DurationTimer")
onready var ghostTimer = get_node("GhostTimer")
const dashDelay = 0.4
const ghostSpawnDelay = 0.03
var canDash = true
var sprite

func startDash(duration, spriteParameter):
	sprite = spriteParameter
	durationTimer.wait_time = duration
	durationTimer.start()
	ghostTimer.start(ghostSpawnDelay)
	instanceGhost()
	
func instanceGhost():
	var ghost = ghostScene.instance()
	get_parent().get_parent().add_child(ghost)
	ghost.global_position = global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	
func isDashing():
	return !durationTimer.is_stopped()

func endDash():
	ghostTimer.stop()
	canDash = false
	yield(get_tree().create_timer(dashDelay), "timeout")
	canDash = true

func _on_Timer_timeout():
	endDash()

func _on_GhostTimer_timeout():
	instanceGhost()
