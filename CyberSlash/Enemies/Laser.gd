extends KinematicBody2D

const speed = 7500 # speed of laser

var velocity = Vector2()
onready var player = load("DemoRoom.tscn").instance().get_node("DemoRoom").get_node("Player")
var dir = 1

func set_dir(new_dir):
	dir = new_dir

func _ready():
	$LaserArea.connect("area_entered", self, "hit_player")

func hit_player(object):
	if object.name == "PlayerArea":
		# hurt player
		self.queue_free()

func _process(delta):
	velocity.x += (dir * speed)

func _physics_process(delta):
	velocity = move_and_slide(velocity * delta)
