extends Node2D

# Enemy Spawning parameters
const max_num_bots = 3 # number of rocket bots to spawn per 
const spawn_time = 5 # number of seconds between enemies spawning

# Enemy Spawning global variables
var num_bots = 0 # number of rocket bots in scene
var timer = Timer.new()
var bot_type = load("res://Enemies/RocketBot.tscn")
var bots = []
var min_x
var max_x

func set_platform_bounds(min_bound, max_bound):
	min_x = min_bound
	max_x = max_bound

func _ready():
	# Enemy Spawning
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.set_wait_time(spawn_time)
	timer.connect("timeout", self, "spawn_bot")
	timer.start()

func spawn_bot():
	var bot = bot_type.instance()
	bot.position.x = $RocketBotSpawner.position.x
	bot.position.y = $RocketBotSpawner.position.y - (bot.get_node("BotArea/CollisionShape2D").shape.extents.y / 2) - 5
	bot.set_player_instance(get_parent().get_parent().get_node("Player"))
	bot.connect("killed",get_parent().get_parent(),"_on_RocketBot_killed")
	bot.set_platform_bounds(min_x, max_x)
	add_child(bot)
	bots.append(bot)
	num_bots += 1
	if num_bots < max_num_bots*2:
		timer.set_wait_time(spawn_time)
		timer.start()
