# Basic Bot Controller

extends KinematicBody2D

export var out_of_bounds = false
export (float) var max_health = 2
export var state = "friendly" # attack, chase, idle

signal health_updated(health)
signal killed()

onready var effects_animation = $DamageAnimationPlayer
onready var laser_scene = load("res://Enemies/Laser.tscn")
onready var direction = 1 # 1 for right, -1 for left; direction enemy is facing
onready var health = max_health setget _set_health
onready var target_pos = position # bot's current target position

const VERT_POS_THRESH = 10 # vertical threshold for enemy being in range of player
const HORI_POS_THRESH = 200 # horizontal threshold for enemy being in range of player
const AMBUSH_DIST = 50 # distance enemy stops from player during ambush
const MAX_SPEED = 2000 # speed enemies walk at
const TIME_BETWEEN_LASERS = 3 # wait time in seconds between lasers shot

var min_x # lower bound of platform as x value
var max_x # upper bound of platform as x value
var vel = Vector2(0, 0) # vel.y should always be 0-- gravity can be implemented when collision bug is fixed
var rand = RandomNumberGenerator.new()
var attack_timer = Timer.new()
var player
var walking_state = "run" # run or idle

func set_platform_bounds(min_bound, max_bound):
	min_x = min_bound
	max_x = max_bound

func damage(object):
	if object.name == "Area2D":
		_set_health(health - 1)
		effects_animation.play("damage")

func kill():
	# modulate is pink: 255, 145, 145
	$DespawnTimer.start()

func despawn():
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	$BotHealthBar/HealthOver.value = health
	$BotHealthBar/UpdateTween.interpolate_property($BotHealthBar/HealthUnder, "value", $BotHealthBar/HealthUnder.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$BotHealthBar/UpdateTween.start()
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")

func set_player_instance(player_instance):
	player = player_instance

func in_range():
	return on_player_platform() and abs(player.position.x - global_position.x) <= HORI_POS_THRESH

# this in range/ on same platform logic should be improved so enemies can fight the player from adjacent platforms
func on_player_platform():
	return abs(player.position.y - global_position.y) <= VERT_POS_THRESH

func attack():
	# shoot laser periodicially
	var laser = laser_scene.instance()
	laser.set_dir(direction)
	laser.position.x = (direction * 7) # 7px is the x offset of the art asset's barrel
	laser.position.y = 0
	$Shooter.add_child(laser)
	if state != "friendly":
		attack_timer.set_wait_time(TIME_BETWEEN_LASERS)
		attack_timer.start() 

func play_anim():
	$AnimatedSprite.stop()
	$AnimatedSprite.play(walking_state)

func start_walk():
	walking_state = "run"
	play_anim()
	walk()

func walk():
	vel.x += (direction * MAX_SPEED)

func start_idle():
	walking_state = "idle"
	play_anim()
	idle()

func idle():
	vel.x = 0

func set_direction(target):
	if (target.x < global_position.x and direction > 0) or (target.x > global_position.x and direction < 0):
		direction *= -1
		$AnimatedSprite.set_flip_h(direction < 0)

func new_target_pos():
	rand.randomize()
	target_pos.x = rand.randi_range(min_x, max_x)
	set_direction(target_pos)

func _ready():
	print(vel)
	start_walk()
	attack_timer.set_one_shot(true)
	self.add_child(attack_timer)
	attack_timer.set_wait_time(1)
	attack_timer.connect("timeout", self, "attack")
	$DamagedTimer.connect("timeout", self, "clear_modulate")
	$DespawnTimer.connect("timeout", self, "despawn")
	$BotArea.connect("area_entered", self, "damage")
	$BotHealthBar/HealthOver.value = max_health
	$BotHealthBar/HealthUnder.value = max_health
	new_target_pos()

func _process(delta):
	if state == "attack":
		# stop walking, continue shooting
		set_direction(player.position)
		idle()
		# if player gets out of ambush distance, state is chase
		if abs(player.position.x - global_position.x) > AMBUSH_DIST:
			state = "chase"
			start_walk()
		# if player is out of range, state is friendly
		if not in_range():
			state = "friendly"
			attack_timer.stop()
			new_target_pos()
			set_direction(target_pos)
			start_walk()
	elif state == "chase":
		# chase player
		set_direction(player.position)
		walk()
		# if bot gets to edge of platform, go to idle state and continue attacking
		# if player gets out of range, state is friendly
		if abs(player.position.x - global_position.x) <= AMBUSH_DIST:
			state = "attack"
			start_idle()
		if not in_range():
			state = "friendly"
			attack_timer.stop()
			new_target_pos()
			set_direction(target_pos)
	else: # "friendly"
		# wander freely around platform
		#print(str(target_pos.x) + " == " + str(position.x))
		if target_pos.x == int(global_position.x):
			new_target_pos()
		walk()
		# if bot gets to edge of platform, switch direction and continue walking
		# if player gets in range of bot, attack
		if in_range():
			state = "attack"
			set_direction(player.position)
			attack()
			start_idle()

func _physics_process(delta):
	vel = move_and_slide(vel * delta)
	#position += vel + (acc / 2)

func _on_DamagedTimer_timeout():
	effects_animation.play("rest")
