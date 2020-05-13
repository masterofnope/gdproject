class_name SwordSlash
extends RigidBody2D

onready var animation_player = $AnimationPlayer

func destroy():
		animation_player.play("destroy")
		
func _on_body_entered(body):
		body.destroy()
