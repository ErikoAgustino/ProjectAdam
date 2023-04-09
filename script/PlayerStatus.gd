extends Node

#signal levelups(level)

var level = 0 
var currentXP = 0
var xpRequireToNextLevel = 0
var strenght = 0
var agility = 0
var intelligence = 0

func _ready():
	initialize(0, 0, 10, 1, 1, 1)

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
	
func getXPRequireToNextLevel(level):
	return round(pow(level, 1.5))

func levelup():
	level += 1
	xpRequireToNextLevel = getXPRequireToNextLevel(level)
	strenght += 1  
	agility += 1
	intelligence += 1
#	emit_signal("levelups", level, xpreq, strenght , agility, intelligence)
