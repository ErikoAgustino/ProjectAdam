extends Control

onready var healthBar = get_node("VBoxContainer/HealthBar")
onready var manaBar = get_node("VBoxContainer/ManaBar")

func _ready():
	PlayerStatus.connect("healthChanged", self, "updateHealth")
	PlayerStatus.connect("manaChanged", self, "updateMana")
	
	healthBar.value = PlayerStatus.currentHealth
	manaBar.value = PlayerStatus.currentMana
	
func updateHealth(hp):
	healthBar.value = hp

func updateMana(mp):
	manaBar.value = mp

func _on_PauseButton_pressed():
	Input.action_press("pause")

func _on_InventoryButton_pressed():
	Input.action_press("inventory")

func _on_Skill1_pressed():
	Input.action_press("skill1")

func _on_Skill2_pressed():
	Input.action_press("skill2")

func _on_DashButton_button_down():
	Input.action_press("dash")