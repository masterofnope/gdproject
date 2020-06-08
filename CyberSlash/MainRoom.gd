extends Node2D

# Enemy Spawning parameters
const max_num_bots = 3 # number of basic bots to spawn
const spawn_time = 5 # number of seconds between enemies spawning

# Enemy Spawning global variables
var num_bots = 0 # number of basic bots in scene

const LIMIT_LEFT = -10000
const LIMIT_TOP = -510
const LIMIT_RIGHT = 10000000000000
const LIMIT_BOTTOM = 300
const LENGTH_CORRIDOR1=360
const LENGTH_STAGE1=1716
const LENGTH_STAGE2=1820
const BACKGROUND_LENGTH=1884
const DEATH_ZONE=510
var loading_point=100
var load_location=1716
var back_loading_point=1000
var back_load_location=BACKGROUND_LENGTH*2
var fore_loading_point=1000
var fore_load_location=BACKGROUND_LENGTH*5
var player
var lastLevel="level1"
var isCorridor=false
var block_instance
var deadBots=0
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
			load_corridor()
		elif lastLevel=="level1":
			load_level2()
		else:
			load_level1()
			
	if player.global_position.x>back_loading_point:
		load_background()
	if player.global_position.y>DEATH_ZONE:
		player.kill()

func load_background():
	var scene = load("res://src/Levels/Background.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("background")
	scene_instance.transform=scene_instance.transform.translated(Vector2(back_load_location,0))
	add_child(scene_instance)
	var scene2 = load("res://src/Levels/Foreground.tscn")
	var scene_instance2 = scene2.instance()
	scene_instance2.set_name("foreground")
	scene_instance2.transform=scene_instance2.transform.translated(Vector2(fore_load_location,0))
	add_child(scene_instance2)
	back_loading_point=back_loading_point+BACKGROUND_LENGTH
	back_load_location=back_load_location+BACKGROUND_LENGTH
	fore_loading_point=fore_loading_point+BACKGROUND_LENGTH*5
	fore_load_location=fore_load_location+BACKGROUND_LENGTH*5
func load_level1():
	var scene = load("res://src/Levels/Level1.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("level1")
	scene_instance.move_local_x(load_location)
	add_child(scene_instance)
	loading_point=loading_point+LENGTH_STAGE1
	load_location=load_location+LENGTH_STAGE1
	isCorridor=false
	lastLevel="level1"
func load_level2():
	var scene = load("res://src/Levels/Level2.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("level2")
	scene_instance.move_local_x(load_location)
	add_child(scene_instance)
	loading_point=loading_point+LENGTH_STAGE2
	load_location=load_location+LENGTH_STAGE2
	isCorridor=false
	lastLevel="level2"
func load_corridor():
	var scene = load("res://src/Levels/Corridor1.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("corridor")
	scene_instance.move_local_x(load_location)
	add_child(scene_instance)
	var blocker = load("res://src/Levels/blocker.tscn")
	block_instance = blocker.instance()
	block_instance.set_name("blocker")
	block_instance.move_local_x(load_location)
	add_child(block_instance)
	loading_point=loading_point+LENGTH_CORRIDOR1
	load_location=load_location+LENGTH_CORRIDOR1
	isCorridor=true

func _on_Player_killed():
	get_tree().change_scene("res://main_menu.tscn")
	pass # Replace with function body.
func _on_BasicBot_killed():
	print("The Main Scene Detected that a bot was killed")
	deadBots+=1
	if deadBots==max_num_bots:
		remove_child(block_instance)
		deadBots=0
