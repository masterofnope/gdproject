extends Node2D

# Enemy Spawning parameters
const max_num_bots = 3 # number of basic bots to spawn per 
const spawn_time = 5 # number of seconds between enemies spawning

# Enemy Spawning global variables
var num_bots = 0 # number of basic bots in scene
var timer = Timer.new()
var bot_type
var bot_type2
var spawner
var spawner2
var bots = []

const LIMIT_LEFT = -10000
const LIMIT_TOP = -10000
const LIMIT_RIGHT = 10000
const LIMIT_BOTTOM = 10000

func _ready():
	# Enemy Spawning
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.set_wait_time(spawn_time)
	print("a level was created")
	if has_node("BasicBotSpawner"):
		spawner = get_node("BasicBotSpawner")
		bot_type = load("res://Enemies/BasicBot.tscn")
	if has_node("BasicBotSpawner2"):
		spawner2 = get_node("BasicBotSpawner2")
		bot_type2 = load("res://Enemies/BasicBot.tscn")
	if has_node("PyroBotSpawner"):
		spawner = get_node("PyroBotSpawner")
		bot_type = load("res://Enemies/PyroBot.tscn")
	if has_node("RocketBotSpawner"):
		spawner2 = get_node("RocketBotSpawner")
		bot_type2 = load("res://Enemies/RocketBot.tscn")
	elif has_node("ConstrBotSpawner"):
		spawner = get_node("ConstrBotSpawner")
		bot_type = load("res://Enemies/ConstrBot.tscn")
	timer.connect("timeout", self, "spawn_bot")
	timer.start()

func spawn_bot():
	var bot = bot_type.instance()
	var bot2=bot_type2.instance()
	bot.position.x = spawner.position.x
	bot2.position.x= spawner2.position.x
	bot.position.y = spawner.position.y - (bot.get_node("BotArea/CollisionShape2D").shape.extents.y / 2) - 5
	bot2.position.y = spawner2.position.y - (bot2.get_node("BotArea/CollisionShape2D").shape.extents.y / 2) - 5
	bot.set_player_instance(get_parent().get_node("Player"))
	bot2.set_player_instance(get_parent().get_node("Player"))
	bot.connect("killed",get_parent(),"_on_BasicBot_killed")
	bot2.connect("killed",get_parent(),"_on_BasicBot_killed")
	add_child(bot)
	add_child(bot2)
	bots.append(bot)
	bots.append(bot2)
	num_bots += 2
	if num_bots < max_num_bots*2:
		timer.set_wait_time(spawn_time)
		timer.start()
