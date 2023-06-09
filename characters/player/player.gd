class_name Player
extends CharacterBody2D

enum State {
	IDLE,
	WALK,
	JUMP,
	DASH
}

signal dead

const DUST = preload("res://effects/dust.tscn")
const JUMP_DUST = preload("res://effects/jump_dust.tscn")
const GHOST_EFFECT = preload("res://characters/player/player_ghost_effect.tscn")
const DUST_EXPLOSION_EFFECT = preload("res://effects/dust_explosion.tscn")
@export var speed : float = 600.0
@export var jump_velocity : float = -1500.0
@export var dash_speed : float = 2000.0
@export var dash_time : int = 15
@export var jump_buffer_time : int = 15
@export var coyote_time : int = 10
@export var max_air_jumps : int = 1
@export var dash_cooldown : float = 0.5
@onready var sprite := $Sprite
@onready var animation_tree := $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]
@onready var dash_cooldown_timer := $DashCooldownTimer
@onready var camera := $Camera
@onready var dust_timer := $DustTimer
@onready var floor_raycast := $FloorRayCast
@onready var ghost_timer := $GhostTimer
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_speed = speed
var is_dashing := false
var dash_counter := 0
var jump_buffer_counter := 0
var coyote_counter := 0
var jump_counter := 0
var is_on_rope := false
var rope_segment : RopeSegment
var can_dash := true
var current_state = State.IDLE
var dash_direction = Vector2.ZERO


func set_camera(limit: Vector4):
	camera.limit_left = limit.x
	camera.limit_top = limit.y
	camera.limit_right = limit.z
	camera.limit_bottom = limit.w


func reset():
	is_dashing = false
	dash_counter = 0
	coyote_counter = 0
	jump_counter = 0
	jump_buffer_counter = 0
	can_dash = true
	_change_state(State.IDLE)
	velocity = Vector2.ZERO


func _die():
	emit_signal("dead")


func _physics_process(delta: float):
	if floor_raycast.is_colliding():
		_add_jump_dust_effect(floor_raycast.get_collision_point())
		floor_raycast.enabled = false
	
	# Add the gravity.
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta
	
	if is_on_floor():
		coyote_counter = coyote_time
		jump_counter = 0
	else:
		if coyote_counter > 0:
			coyote_counter -= 1
		if jump_buffer_counter > 0 and jump_counter < max_air_jumps:
			jump_counter += 1
			coyote_counter = 1
			_add_jump_dust_effect(to_global(floor_raycast.target_position))
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and coyote_counter > 0:
		velocity.y = jump_velocity
		jump_buffer_counter = 0
		coyote_counter = 0
		floor_raycast.enabled = true
		_change_state(State.JUMP)

	# Handle Dash
	if Input.is_action_just_pressed("dash") and not is_dashing and can_dash:
		var up_down = Input.get_axis("move_up", "move_down")
		var left_right = Input.get_axis("move_left", "move_right")
		dash_direction = Vector2(
			ceili(abs(left_right)) * sign(left_right),
			ceili(abs(up_down)) * sign(up_down))
		if dash_direction == Vector2.ZERO:
			if sprite.flip_h:
				dash_direction = Vector2.LEFT
			else:
				dash_direction = Vector2.RIGHT
		is_dashing = true
		can_dash = false
		dash_counter = dash_time
		if ghost_timer.is_stopped():
			ghost_timer.start()
			_add_dust_explosion()
		_change_state(State.DASH)
	if is_dashing:
		velocity = dash_direction * dash_speed
		if velocity.y > 0 and is_on_floor():
			dash_counter = 0
		if dash_counter > 0:
			dash_counter -= 1
		else:
			is_dashing = false
			velocity = Vector2.ZERO
			if dash_cooldown_timer.is_stopped():
				dash_cooldown_timer.start(dash_cooldown)
		move_and_slide()
		return

	if dash_counter <= 0:
		ghost_timer.stop()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var left_right = Input.get_axis("move_left", "move_right")
	var direction = ceili(abs(left_right)) * sign(left_right)
	if direction:
		sprite.flip_h = direction < 0
		velocity.x = direction * speed
		if is_on_floor() and velocity.y == 0:
			_change_state(State.WALK)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if velocity.length() == 0:
		_change_state(State.IDLE)
	
	move_and_slide()


func _change_state(state: State):
	if state == current_state:
		return
	match state:
		State.IDLE: state_machine.travel('idle')
		State.WALK: state_machine.travel('walk')
		State.JUMP: state_machine.travel('jump')
		State.DASH: state_machine.travel('dash')
	current_state = state
	if current_state == State.WALK and dust_timer.is_stopped():
		dust_timer.start()
	else:
		dust_timer.stop()


func _add_jump_dust_effect(position_to_add: Vector2):
	var dust = JUMP_DUST.instantiate()
	dust.global_position = position_to_add
	get_parent().add_child(dust)


func _add_dust_explosion():
	var dust_explosion = DUST_EXPLOSION_EFFECT.instantiate()
	dust_explosion.global_position = global_position
	get_parent().add_child(dust_explosion)


func _on_visible_on_screen_notifier_screen_exited():
	_die()


func _on_dash_cooldown_timer_timeout():
	can_dash = true


func _on_hurt_box_body_entered(_body):
	_die()


func _on_hurt_box_area_entered(_area):
	_die()


func _on_dust_timer_timeout():
	var dust = DUST.instantiate()
	dust.global_position = global_position + Vector2(0, 35)
	dust.emitting = true
	get_parent().add_child(dust)


func _on_ghost_timer_timeout():
	var ghost = GHOST_EFFECT.instantiate()
	ghost.global_position = global_position
	ghost.flip_h = sprite.flip_h
	get_parent().add_child(ghost)
