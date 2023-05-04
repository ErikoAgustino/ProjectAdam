extends Node

#signal levelups(level)
signal healthChanged(health)
signal manaChanged(mana)

var level = 0
var currentXP = 0
var xpRequireToNextLevel = 0
var strenght = 0
var agility = 0
var intelligence = 0
var currentHealth = 80 setget changeHealth
var currentMana = 80 setget changeMana
var maxHealth = 100
var maxMana = 100

func _ready():
	initialize(0, 0, 10, 1, 1, 1)

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
		currentXP = currentXP % xpRequireToNextLevel
		levelup()
	
func getXPRequireToNextLevel(level):
	return round(pow(level, 1.5))

func levelup():
	level += 1
	xpRequireToNextLevel = getXPRequireToNextLevel(level)
	strenght += 1  
	agility += 1
	intelligence += 1
#	emit_signal("levelups", level, xpreq, strenght , agility, intelligence)
