class_name Player
extends Actor

const FLOOR_DETECT_DISTANCE = 15.0

export(String) var action_suffix = ""

onready var platform_detector = $PlatformDetector
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var slash_timer = $SlashAnimation
onready var horizontal_slash = $Sprite/HorizontalSlash

func _ready():
	var camera: Camera2D = $Camera
	if action_suffix == "_p1":
		camera.custom_viewport = $"../.."
	elif action_suffix == "_p2":
		var viewport: Viewport = $"../../../../ViewportContainer2/Viewport"
		viewport.world_2d = ($"../.." as Viewport).world_2d
		camera.custom_viewport = viewport
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
