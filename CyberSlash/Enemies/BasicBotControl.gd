# Pyro Bot Controller
# Jordyn Marlow

extends KinematicBody2D

signal health_updated(health)
signal killed()

const vert_pos_thresh = 10 # vertical threshold for enemy being in range of player
const hori_pos_thresh = 100 # horizontal threshold for enemy being in range of player
const ambush_dist = 50 # distance enemy stops from player during ambush
var min_shoot_time = 1 # minimum seconds between lasers shot
var max_shoot_time = 3 # maximum seconds between lasers shot
var max_speed = 2000 # speed enemies walk at
var min_x = -28
var max_x = 419

onready var laser_scene = load("res://Enemies/Laser.tscn")
onready var direction = 1 # 1 for right, -1 for left
var velocity = Vector2()
var rand = RandomNumberGenerator.new()
var attack_timer = Timer.new()
var player
export var state = "friendly" # attack, chase, idle
var walking_state = "run" # run or idle
export (float) var max_health = 100
onready var health = max_health setget _set_health

func damage(amount):
	_set_health(health - amount)
	set_modulate(Color(255, 145, 145))
	$DamagedTimer.start()

func clear_modulate():
	set_modulate(Color(255, 255, 255))

func kill():
	set_modulate(Color(255, 145, 145))
	$DespawnTimer.start()

func despawn():
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")

func set_player_instance(player_instance):
	player = player_instance

func in_range():
	if abs(player.position.y - position.y) <= vert_pos_thresh and abs(player.position.x - position.x) <= hori_pos_thresh:
		return true
	return false

func attack():
	# shoot laser periodicially
	var laser = laser_scene.instance()
	laser.set_dir(direction)
	laser.position.x = (direction * 7) # 7px is the x offset of the art asset's barrel
	laser.position.y = 0
	$Shooter.add_child(laser)
	attack_timer.set_wait_time(3)
	attack_timer.start()

func play_anim():
	$AnimatedSprite.stop()
	$AnimatedSprite.play(walking_state)

func start_walk():
	walking_state = "run"
	play_anim()
	walk()

func walk():
	velocity.x += (direction * max_speed)

func start_idle():
	walking_state = "idle"
	play_anim()
	idle()

func idle():
	velocity.x = 0

func switch_direction():
	direction *= -1
	$AnimatedSprite.set_flip_h(direction < 0)

func face_player():
	if player.position.x < position.x and direction > 0:
		switch_direction()
	if player.position.x > position.x and direction < 0:
		switch_direction()

func _ready():
	start_walk()
	attack_timer.set_one_shot(true)
	self.add_child(attack_timer)
	attack_timer.set_wait_time(1)
	attack_timer.connect("timeout", self, "attack")
	$DamagedTimer.connect("timeout", self, "clear_modulate")
	$DespawnTimer.connect("timeout", self, "despawn")

func _process(_delta):
	rand.randomize()
	if state == "attack":
		# stop moving
		face_player()
		idle()
		# if player is not within range, state == chase
		if not in_range():
			state = "chase"
			start_walk()
	elif state == "chase":
		# move toward player
		walk()
		# if player is within range, state == attack
		if in_range():
			state = "attack"
			start_idle()
	else: # friendly
		# move freely on platform
		if position.x <= min_x or position.x >= max_x:
			switch_direction()
			start_walk()
		elif rand.randi_range(0, 500) == 0:
			switch_direction()
		if rand.randi_range(0, 1000) == 0:
			if walking_state == "run":
				start_idle()
			else: # idle
				start_walk()
		else:
			if walking_state == "run":
				walk()
			else: # idle
				idle()
		# if player is within range, state == attack
		if in_range():
			state = "attack"
			face_player()
			start_idle()
			attack_timer.start()

func _physics_process(delta):
	velocity = move_and_slide(velocity * delta)


