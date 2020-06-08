extends Area2D


onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

#onready var playernode = get_node("/root/Game/DemoRoom/TileMap2/Player")
var picked_up = false

func _on_Faster_attacks_body_entered(body):
	if picked_up == false:
		picked_up = true
		anim_player.play("faster_attacks_pickup")
		body.attack_anim.playback_speed = body.attack_anim.playback_speed * 1.1
		body.slash_timer.wait_time = body.slash_timer.wait_time * .9
		print(body.attack_anim.playback_speed)
	else:
		print("nahfambudbuddyboi")



