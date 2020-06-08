extends KinematicBody2D

const speed = 7500 # speed of laser
const damage = 1 # hits to player health

var velocity = Vector2()
onready var player = load("DemoRoom.tscn").instance().get_node("DemoRoom").get_node("Player")
var dir = 1

func set_dir(new_dir):
	dir = new_dir

func _ready():
	$LaserArea.connect("area_entered", self, "hit_player")

func hit_player(object):
	if object.name == "PlayerArea":
		object.get_parent().damage(damage)
		self.queue_free()
	elif object.name == "Area2D":
		self.queue_free()

func _process(delta):
	velocity.x += (dir * speed)

func _physics_process(delta):
	velocity = move_and_slide(velocity * delta)

func _on_Lifetime_timeout():
	queue_free()

