extends Node

var max_num_enemies = 3 # number of enemies to spawn
var num_enemies = 0 # number of enemies currently in scene
var min_spawn_time = 3 # minimum seconds between 2 enemies spawning
var max_spawn_time = 7 # maximum seconds between 2 enemies spawning
var timer
var rand

func spawn():
	var enemies_scene = load("res://Enemies.tscn")
	var enemy = enemies_scene.instance()
	var basic = enemy.get_node("BasicBot")
	var main_scene = load("res://DemoRoom.tscn")
	var main = main_scene.instance()
	#basic.position.x = main.get_node("TileMap").position.x + 630
	#basic.position.y = main.get_node("TileMap").position.y + 157
	basic.position.x = 630
	basic.position.y = 157
	add_child(basic)
	num_enemies += 1
	if num_enemies < max_num_enemies:
		timer.set_wait_time(rand.randi_range(min_spawn_time, max_spawn_time))
		timer.start()

func _ready():
	rand = RandomNumberGenerator.new()
	rand.randomize()
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.connect("timeout", self, "spawn")
	self.add_child(timer)
	timer.set_wait_time(rand.randi_range(min_spawn_time, max_spawn_time))
	timer.start()
	
