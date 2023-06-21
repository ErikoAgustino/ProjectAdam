extends Control

onready var healthBar = get_node("VBoxContainer/HealthBar")
onready var expBar = get_node("VBoxContainer/EXPBar")
onready var levelLabel = get_node("VBoxContainer/EXPBar/LevelLabel")
onready var floorLabel = get_node("FloorLabel")
func _ready():
	PlayerStatus.connect("healthChanged", self, "updateHealth")
	PlayerStatus.connect("expChanged", self, "updateEXP")
	PlayerStatus.connect("levelups", self, "updateLevel")

	levelLabel.text = "Level " + String(PlayerStatus.level)
	
	healthBar.value = PlayerStatus.currentHealth
	healthBar.max_value = PlayerStatus.maxHealth
	
	expBar.value = PlayerStatus.currentXP
	expBar.max_value = PlayerStatus.xpRequireToNextLevel
	
	floorLabel.text = "Floor " + String(GameManager.currentLevel) 
	
func updateHealth(hp):
	healthBar.value = hp

func updateEXP(xp):
	expBar.value = xp
	
func updateLevel(level, xpReq):
	expBar.value = 0
	expBar.max_value = xpReq
	levelLabel.text = "Level " + String(level)

func _on_PauseButton_pressed():
	Input.action_press("pause")

func _on_InventoryButton_pressed():
	Input.action_press("inventory")

func _on_Skill1_pressed():
	Input.action_press("skill1")

func _on_Skill2_pressed():
	Input.action_press("skill2")

func _on_DashButton_pressed():
	Input.action_press("dash")
