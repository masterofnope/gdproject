# Turret Controller
# Jordyn Marlow

extends Node2D

export var health = 3 # 2 hits to kill

func hurt_bot(): # call this function on collision
	health -= 1

