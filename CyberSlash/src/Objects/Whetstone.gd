extends Area2D


onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

#onready var playernode = get_node("/root/Game/DemoRoom/TileMap2/Player")
var picked_up = false

func _on_body_entered(body):
	if picked_up == false:
		picked_up = true
		anim_player.play("pickup")
		body.speed.x = body.speed.x + 100
		print(body.speed.x)
	else:
		print("nahfambudbuddyboi")




