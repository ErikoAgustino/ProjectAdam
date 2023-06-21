extends Control

onready var tween = $Tween
onready var creditContainer = $CreditContainer

func _ready():
	$FadeScreen.fadeOut()
	SoundManager.play_bgm("mainMenu")

func _on_settings_pressed():
	get_tree().change_scene("res://scene/ui/Settings.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_continue_pressed():
	playLevelBGM()
	
func _on_newgame_pressed():
	PlayerStatus.initialize(1, 0, 10, 1, 1, 1)
	PlayerStatus.changeHealth(100)
	GameManager.currentLevel = 0
	$FadeScreen.fadeIn()
	yield(get_tree().create_timer(0.5), "timeout")
	playLevelBGM()
	get_tree().change_scene("res://scene/level/Tutorial.tscn")

func _on_credit_pressed():
	if(creditContainer.rect_position.x > 1000):
		tween.interpolate_property(creditContainer, "rect_position", creditContainer.rect_position, Vector2(800, 410), 0.5, Tween.EASE_IN_OUT)
	else:
		tween.interpolate_property(creditContainer, "rect_position", creditContainer.rect_position, Vector2(1300, 410), 0.5, Tween.EASE_IN_OUT)
	tween.start()
	
func playLevelBGM():
	SoundManager.stop("mainMenu")
	SoundManager.play_bgm("level")
