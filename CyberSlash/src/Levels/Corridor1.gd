extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var i= randi()%3
	var powerup
	if i==0:
		powerup = load("res://src/Objects/Faster_attacks.tscn")
	elif i==1:
		powerup = load("res://src/Objects/Multi_jump.tscn")
	else:
		powerup=load("res://src/Objects/Whetstone.tscn")
	var instance = powerup.instance()
	instance.set_name("powerup")
	instance.transform=instance.transform.translated(Vector2(275,-50))
	add_child(instance)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
