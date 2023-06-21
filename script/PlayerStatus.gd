extends Node

signal levelups(level, expReq)
signal healthChanged(health)
signal manaChanged(mana)
signal expChanged(ex)

var level = 1
var currentXP = 0
var xpRequireToNextLevel = 0
var strenght = 0
var agility = 0
var intelligence = 0
var currentHealth = 100 setget changeHealth
var currentMana = 100 setget changeMana
var maxHealth = 100
var maxMana = 100

func _ready():
	initialize(1, 0, 10, 1, 1, 1)

func changeHealth(hp):
	currentHealth = hp
	emit_signal("healthChanged", currentHealth)

func changeMana(mp):
	currentMana = mp
	emit_signal("manaChanged", currentMana)

func initialize(level, currentXP, xpRequireToNextLevel, strenght, agility, intelligence):
	self.level = level
	self.currentXP = currentXP
	self.xpRequireToNextLevel = xpRequireToNextLevel
	self.strenght = strenght
	self.agility = agility
	self.intelligence = intelligence

func addXP(amount):
	currentXP += amount
	while currentXP >= xpRequireToNextLevel :
		currentXP = 0
		levelup()
	emit_signal("expChanged", currentXP)
	
func getXPRequireToNextLevel(level):
	return round(pow(level, 1.5))

func levelup():
	level += 1
	xpRequireToNextLevel = getXPRequireToNextLevel(level)
	strenght += 1  
	agility += 1
	intelligence += 1
	changeHealth(100)
	emit_signal("levelups", level, xpRequireToNextLevel)
