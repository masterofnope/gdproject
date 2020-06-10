class_name Player
extends Actor

const FLOOR_DETECT_DISTANCE = 15.0

export(String) var action_prefix = ""

signal health_updated(health)
signal timeout()
signal killed()

export (float) var max_health = 10

onready var platform_detector = $PlatformDetector
onready var sprite = $AnimatedSprite
onready var animation_player = $Body/AnimationPlayer
onready var slash_timer = $SlashAnimation
onready var invul_timer = $InvulnerabilityTimer
onready var effects_animation = $Body/DamageAnimationPlayer
onready var current_health = max_health setget _set_health
onready var attack_anim = $Body/AttackPlayer
onready var attack_sound = $SlashSound
onready var attack_cooldown = $SlashAnimation
onready var attack_box = $Area2D/AttackHitbox
onready var health_bar = $HealthBar

onready var multijumps = 0
onready var maxmultijumps = 0
onready var is_hor_slashing = false

func _ready():
	var camera: Camera2D = $Camera
	if action_prefix == "p_":
		camera.custom_viewport = $"../.."
	attack_cooldown.connect("timeout",self,"_on_attack_cooldown_end")
	invul_timer.connect("timeout", self, "_on_InvulnerabilityTimer_timeout")
	health_bar._on_max_health_updated(max_health)

func reset_jumps(doordonot):
	if doordonot:
		multijumps = maxmultijumps

func _physics_process(_delta):
	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("p_move_jump") and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	reset_jumps(is_on_floor())
	
	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)

	if direction.x != 0:
		sprite.scale.x = 1 if direction.x > 0 else -1
		$Area2D.scale.x = 1 if direction.x > 0 else -1

	# We use the sprite's scale to store Robi’s look direction which allows us to shoot
	# bullets forward.
	# There are many situations like these where you can reuse existing properties instead of
	# creating new variables.
	if Input.is_action_just_pressed(action_prefix + "p_attack_horizontal") and is_hor_slashing == false:
		is_hor_slashing = true
		attack_cooldown.start()
		attack_anim.play("slash")
		attack_sound.play()
		


	var animation = get_new_animation(is_hor_slashing)
	if animation != animation_player.current_animation:
		sprite.play(animation)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_attack_cooldown_end():
	is_hor_slashing = false
	

func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y += speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity

func get_direction():
	var yvel = 0
	if is_on_floor() and Input.is_action_just_pressed("p_move_jump"):
		yvel = -1
	elif multijumps >=1 and Input.is_action_just_pressed("p_move_jump"):
		yvel = -1
		multijumps -= 1
		_velocity.y = 0.0
	else: yvel = .05
	return Vector2(
		Input.get_action_strength("p_move_right") - Input.get_action_strength("p_move_left"),
		yvel
	)

func get_new_animation(is_shooting):
	var animation_new = ""
	if is_on_floor():
		animation_new = "run" if _velocity.x != 0 else "idle"
	#else:
	#	animation_new = "falling" if _velocity.y > 0 else "jumping"
	#if _velocity.x != 0:
	if is_shooting:
		animation_new = "attack"
	if is_shooting and _velocity.x !=0:
		animation_new = "attack_move"
	return animation_new

func damage(damage_amount):
	invul_timer.start()
	invul_timer.stop()
	if invul_timer.is_stopped():
		invul_timer.start()
		_set_health(current_health - damage_amount)
		effects_animation.play("damage")
		effects_animation.queue("flash")
		#effects_animation.queue("rest")

func _set_health(value):
	var prev = current_health
	current_health = clamp(value, 0, max_health)
	health_bar._on_health_updated(current_health)
	if current_health != prev:
		emit_signal("health_updated", current_health)
		if current_health == 0: 
			kill()
			
func kill ():
	print("player killed")
	emit_signal("killed")



func _on_InvulnerabilityTimer_timeout():
	effects_animation.play("rest")
	print("Invul Timer Timed Out")
