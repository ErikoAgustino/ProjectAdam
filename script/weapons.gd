extends Node

var weapontype : String
var quality : String
var names : String
var strenght : int
var agility : int
var intelligence : int
var strreq : int
var agireq : int
var intreq : int

func initialize(weapon : baseweapon):
	weapontype = weapon.weapontype
	quality = weapon.quality
	names = weapon.name
	strenght = weapon.strenght
	agility = weapon.agility
	intelligence = weapon.intelligence
	strreq = weapon.strreq
	agireq = weapon.agireq
	intreq = weapon.intreq


