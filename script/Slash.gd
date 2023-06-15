extends Node2D

const ghostScene = preload("res://scene/character/SlashGhost.tscn")
const whiteCircle = preload("res://Asset/whitecircle.png")

onready var durationTimer = get_node("DurationTimer")
onready var slashTimer = get_node("SlashTimer")
const dashDelay = 0.4
const ghostSpawnDelay = 0.03
var sprite

func startSlash(duration, spriteParameter):
	sprite = spriteParameter
	durationTimer.wait_time = duration
	durationTimer.start()
	slashTimer.start(ghostSpawnDelay)
	instanceSlash()
	
func instanceSlash():
	var ghost = ghostScene.instance()
	get_parent().get_parent().add_child(ghost)
	ghost.global_position = global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h

func endDash():
	slashTimer.stop()

func _on_DurationTimer_timeout():
	endDash()

func _on_SlashTimer_timeout():
	instanceSlash()
