extends Node2D

# Enemy Spawning parameters
const max_num_bots = 3 # number of basic bots to spawn
const spawn_time = 5 # number of seconds between enemies spawning

# Enemy Spawning global variables
var num_bots = 0 # number of basic bots in scene
var timer = Timer.new()
var bot_type
var spawner
var bots = []

const LIMIT_LEFT = -10000
const LIMIT_TOP = -10000
const LIMIT_RIGHT = 10000
const LIMIT_BOTTOM = 10000

func _ready():
	for child in get_children():
		if child is Player:
			var camera = child.get_node("Camera")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_right = LIMIT_RIGHT
			camera.limit_bottom = LIMIT_BOTTOM
	# Enemy Spawning
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.set_wait_time(spawn_time)
	if has_node("BasicBotSpawner"):
		spawner = get_node("BasicBotSpawner")
		bot_type = load("res://Enemies/BasicBot.tscn")
	if has_node("PyroBotSpawner"):
		spawner = get_node("PyroBotSpawner")
		bot_type = load("res://Enemies/PyroBot.tscn")
	elif has_node("RocketBotSpawner"):
		spawner = get_node("RocketBotSpawner")
		bot_type = load("res://Enemies/RocketBot.tscn")
	elif has_node("ConstrBotSpawner"):
		spawner = get_node("ConstrBotSpawner")
		bot_type = load("res://Enemies/ConstrBot.tscn")
	timer.connect("timeout", self, "spawn_bot")
	timer.start()

func spawn_bot():
	var bot = bot_type.instance()
	bot.position.x = spawner.position.x
	bot.position.y = spawner.position.y - (bot.get_node("BotArea/CollisionShape2D").shape.extents.y / 2) - 5
	bot.set_player_instance(get_node("Player"))
	add_child(bot)
	bots.append(bot)
	num_bots += 1
	if num_bots < max_num_bots:
		timer.set_wait_time(spawn_time)
		timer.start()
