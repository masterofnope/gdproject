extends Node2D


const LIMIT_LEFT = -10000
const LIMIT_TOP = -510
const LIMIT_RIGHT = 10000000000000
const LIMIT_BOTTOM = 10000
const LENGTH_CORRIDOR1=360
const LENGTH_STAGE1=1716
const LENGTH_STAGE2=1820
const BACKGROUND_LENGTH=1884
var loading_point=1000
var load_location=1716
var back_loading_point=1000
var back_load_location=BACKGROUND_LENGTH/2
var player
var lastLevel="level1"
var isCorridor=false
func _ready():
	for child in get_children():
		if child is Player:
			player=child
			var camera = child.get_node("Camera")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_right = LIMIT_RIGHT
			camera.limit_bottom = LIMIT_BOTTOM
			
			
func _process(delta):
	if player.global_position.x>loading_point:
		if !isCorridor:
			var scene = load("res://src/Levels/Corridor1.tscn")
			var scene_instance = scene.instance()
			scene_instance.set_name("scene")
			scene_instance.move_local_x(load_location)
			add_child(scene_instance)
			loading_point=loading_point+LENGTH_CORRIDOR1
			load_location=load_location+LENGTH_CORRIDOR1
			isCorridor=true
		elif lastLevel=="level1":
			var scene = load("res://src/Levels/Level2.tscn")
			var scene_instance = scene.instance()
			scene_instance.set_name("scene")
			scene_instance.move_local_x(load_location)
			add_child(scene_instance)
			loading_point=loading_point+LENGTH_STAGE2
			load_location=load_location+LENGTH_STAGE2
			isCorridor=false
			lastLevel="level2"
		else:
			var scene = load("res://src/Levels/Level1.tscn")
			var scene_instance = scene.instance()
			scene_instance.set_name("scene")
			scene_instance.move_local_x(load_location)
			add_child(scene_instance)
			loading_point=loading_point+LENGTH_STAGE1
			load_location=load_location+LENGTH_STAGE1
			isCorridor=false
			lastLevel="level1"
			
	if player.global_position.x>back_loading_point:
		var scene = load("res://src/Levels/Background.tscn")
		var scene_instance = scene.instance()
		scene_instance.set_name("background")
		scene_instance.transform=scene_instance.transform.translated(Vector2(back_load_location,0))
		var scene2 = load("res://src/Levels/Foreground.tscn")
		var scene_instance2 = scene.instance()
		scene_instance2.set_name("background")
		scene_instance2.transform=scene_instance2.transform.translated(Vector2(back_load_location,0))
		add_child(scene_instance)
		back_loading_point=back_loading_point+BACKGROUND_LENGTH
		back_load_location=back_load_location+BACKGROUND_LENGTH
