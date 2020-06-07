class_name Player
extends Actor

const FLOOR_DETECT_DISTANCE = 15.0

export(String) var action_prefix = ""

signal health_updated(health)
signal killed()

export (float) var max_health = 5

onready var platform_detector = $PlatformDetector
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var slash_timer = $SlashAnimation
onready var sword = $Sprite/Sword
onready var effects_animation = $Body/damageAnimationPlayer
onready var current_health = max_health setget _set_health

onready var multijumps = 0
onready var maxmultijumps = 0

var format_string = "HP: %s / %s"
var actual_string = format_string % [current_health, max_health]

func _ready():
	var camera: Camera2D = $Camera
	if action_prefix == "p_":
		camera.custom_viewport = $"../.."

		
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

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.
	if direction.x != 0:
		sprite.scale.x = 1 if direction.x > 0 else -1

	# We use the sprite's scale to store Robi’s look direction which allows us to shoot
	# bullets forward.
	# There are many situations like these where you can reuse existing properties instead of
	# creating new variables.
	var is_hor_slashing = false
	if Input.is_action_just_pressed(action_prefix + "attack_horizontal"):
		is_hor_slashing = sword.horizontal_slash(sprite.scale.x)


	var animation = get_new_animation(is_hor_slashing)
	if animation != animation_player.current_animation and slash_timer.is_stopped():
		if is_hor_slashing:
			slash_timer.start()
		#animation_player.play(animation)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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

func get_new_animation(is_shooting = false):
	var animation_new = ""
	if is_on_floor():
		animation_new = "run" if abs(_velocity.x) > 0.1 else "idle"
	#else:
	#	animation_new = "falling" if _velocity.y > 0 else "jumping"
	if is_shooting:
		animation_new += "_weapon"
	return animation_new

func damage(damage_amount): 
	if invul_timer.is_stopped():
		invul_timer.start()
		_set_health(current_health - damage_amount)
		effects_animation.play("damage")
		effects_animation.queue("flash")

func _set_health(value):
	var prev = current_health
	current_health = clamp(value, 0, max_health)
	if current_health != prev:
		emit_signal("health_updated", current_health)
		if current_health == 0: 
			kill()
			emit_signal("Killed")
			
func kill ():
	pass


func _on_InvulnerabilityTimer_timeout():
	effects_animation.play("rest")
