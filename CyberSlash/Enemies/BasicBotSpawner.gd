extends Node2D

# Enemy Spawning parameters
const max_num_bots = 3 # number of basic bots to spawn per 
const spawn_time = 5 # number of seconds between enemies spawning

# Enemy Spawning global variables
var num_bots = 0 # number of basic bots in scene
var timer = Timer.new()
var bot_type = load("res://Enemies/BasicBot.tscn")
onready var player = get_parent().get_parent().get_node("Player")
var bots = []
var min_x
var max_x
var activated = false

func set_platform_bounds(min_bound, max_bound):
	min_x = min_bound
	max_x = max_bound

func _ready():
	# Enemy Spawning
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.set_wait_time(spawn_time)
	timer.connect("timeout", self, "spawn_bot")

func _process(delta):
	if abs(player.position.x - $BasicBotSpawner.global_position.x) < 500 and abs(player.position.y - $BasicBotSpawner.global_position.y) < 500 and not activated:
		print("activate spawner")
		activated = true
		timer.start()

func spawn_bot():
	var bot = bot_type.instance()
	bot.position.x = $BasicBotSpawner.position.x
	bot.position.y = $BasicBotSpawner.position.y - (bot.get_node("BotArea/CollisionShape2D").shape.extents.y / 2) - 5
	bot.set_player_instance(player)
	bot.connect("killed",get_parent().get_parent(),"_on_BasicBot_killed")
	bot.connect("killed",get_parent().get_parent().get_node("Player"),"_on_Bot_killed")
	bot.set_platform_bounds(min_x, max_x)
	add_child(bot)
	bots.append(bot)
	num_bots += 1
	if num_bots < max_num_bots:
		timer.set_wait_time(spawn_time)
		timer.start()
