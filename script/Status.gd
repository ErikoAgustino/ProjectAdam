extends Node

signal levelups(level)

var level : int
var xp : int
var xpt : int 
var xpreq : int
var strenght : int
var agility : int
var intelligence : int

func initialize(stats : basestats):
	level = stats.level
	xp = stats.xp
	xpt = stats.xpt
	xpreq = get_xpreq(level+1)
	strenght = stats.strenght
	agility = stats.agility
	intelligence = stats.intelligence

func get_xp(amouth):
	xpt += amouth
	xp += amouth
	while xp >= xpreq :
		xp -= xpreq
		levelup()
	
func get_xpreq(level):
	return round(pow(level, 1.5))

func levelup():
	level +=1
	xpreq = get_xpreq(level)
	strenght += 1  
	agility += 1
	intelligence += 1
	emit_signal("levelups", level, xpreq, strenght , agility, intelligence)
