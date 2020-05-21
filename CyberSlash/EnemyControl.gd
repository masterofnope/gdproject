extends KinematicBody2D

var vert_pos_thresh = 5 # vertical threshold for enemy being in range of player
var hori_pos_thresh = 100 # horizontal threshold for enemy being in range of player
var ambush_dist = 50 # distance enemy stops from player during ambush
var min_shoot_time = 1 # minimum seconds between lasers shot
var max_shoot_time = 3 # maximum seconds between lasers shot
var min_speed = 0 # minimum speed enemy can travel
var max_speed = 4000 # maximum speed enemy can travel
var min_x = 175
var max_x = 897

onready var enemies_scene = load("Enemies.tscn")
onready var enemy = enemies_scene.instance()
onready var basic = enemy.get_node("BasicBot")
onready var main_scene = load("DemoRoom.tscn")
onready var main = main_scene.instance()
onready var player = main.get_node("Player")
onready var direction = true
onready var move = true
var velocity = Vector2()
var rand = RandomNumberGenerator.new()

func switch_dir():
	direction = not direction
	$AnimatedSprite.set_flip_h(not direction)

func move_bot(speed):
	if move:
		if direction:
			velocity.x += rand.randi_range(min_speed, max_speed)
		else:
			velocity.x -= rand.randi_range(min_speed, max_speed)
	
func attack():
	# shoot laser periodicially
	pass
	
func _process(delta):
	# if enemy is in range of player, attack
	#if abs(player.position.y - position.y) <= vert_pos_thresh and abs(player.position.x - position.x) <= hori_pos_thresh:
		#if abs(player.position.x - position.x) > ambush_dist: # should enemy back up if player gets closer?
			# move
			#pass
		# attack player
		#pass
	#else: #otherwise, move freely
	rand.randomize()
	var temp = rand.randi_range(0, 250)
	if temp == 0:
		switch_dir()
	temp = rand.randi_range(0, 750)
	if temp == 0:
		move = not move
		if move:
			# stop idle, play walk
			$AnimatedSprite.stop()
			$AnimatedSprite.play("walk")
		else:
			# stop walk, play idle
			$AnimatedSprite.stop()
			$AnimatedSprite.play("idle")
	move_bot(rand.randf_range(100, 5000))

func _physics_process(delta):
	velocity = move_and_slide(velocity * delta)









