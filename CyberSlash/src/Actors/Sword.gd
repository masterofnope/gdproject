class_name Sword
extends Position2D

onready var slash_sound = $Slash
onready var timer = $Cooldown

#const SwordSlash = preload("res://src/Objects/SwordSlash.tscn")

var SLASH_DAMAGE = 50

func horizontal_slash(direction = 1):
#
#	if not timer.is_stopped():
#		return false
#	var bullet = Bullet.instance()
#	bullet.global_position = global_position
#	bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0)
#
#	bullet.set_as_toplevel(true)
#	add_child(bullet)
#	sound_shoot.play()
	return true


