extends Node

var max_num_bots = 3 # number of basic bots to spawn
var num_bots = 0 # number of basic bots in scene
var min_spawn_time = 3 # minimum seconds between 2 enemies spawning
var max_spawn_time = 7 # maximum seconds between 2 enemies spawning
var timer = Timer.new()
var rand
var bot
var spawner

var main_scene = load("res://DemoRoom.tscn")
var main = main_scene.instance()

func spawn():
	bot.position.x = spawner.position.x
	bot.position.y = spawner.position.y
	add_child(bot)
	num_bots += 1
	if num_bots < max_num_bots:
		timer.set_wait_time(rand.randi_range(min_spawn_time, max_spawn_time))
		timer.start()

func _ready():
	rand = RandomNumberGenerator.new()
	rand.randomize()
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.set_wait_time(rand.randi_range(min_spawn_time, max_spawn_time))
	if main.get_node("TileMap").has_node("BasicBotSpawner"):
		print("basic")
		spawner = main_scene.get_node("BasicBotSpawner")
		bot = load("res://Enemies/BasicBot.tscn").instance()
	elif main.get_node("TileMap").has_node("PyroBotSpawner"):
		spawner = main.get_node("PyroBotSpawner")
		bot = load("res://Enemies/PyroBot.tscn").instance()
	elif main.has_node("RocketBotSpawner"):
		spawner = main.get_node("RocketBotSpawner")
		bot = load("res://Enemies/RocketBot.tscn").instance()
	elif main.has_node("ConstrBotSpawner"):
		spawner = main.get_node("ConstrBotSpawner")
		bot = load("res://Enemies/ConstrBot.tscn").instance()
	print("else")
	timer.connect("timeout", self, "spawn")
	timer.start()
