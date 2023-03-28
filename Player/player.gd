extends CharacterBody2D

const SPEED = 200.0
const FRICTION = 25
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var playerActionAnimation = $PlayerAction
@onready var playerSprite = $Sprite2D
@onready var foot = $Foot
@onready var hurtBox = $HurtBox
@onready var attackTimer = $AttackTimer
@onready var blinkEffectAnimation:AnimationPlayer = $BlinkEffectAnimation

var Bomb = preload("res://Bomb/bomb.tscn")

enum {
	IDLE,
	RUN,
	JUMP,
	HURTING
}

var CD = 1.0
var state = RUN
var is_jumping = false
var can_attack = true

var recentDirection = 0

func _physics_process(delta):
	if hurtBox.is_invincible():
		blinkEffectAnimation.play("start")
	else:
		blinkEffectAnimation.stop()
		blinkEffectAnimation.play("RESET")
		
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		state = JUMP
	if Input.is_action_just_pressed("attack"):
		if state != HURTING:
			attack()
	match state:
		JUMP:
			jump_state(direction)
		RUN:
			move_state(direction)
		HURTING:
			hurting_state()
	if velocity.y < 0:
		self.set_collision_layer_value(7,false)
		self.set_collision_mask_value(6,false)
	else: 
		self.set_collision_layer_value(7,true)
		self.set_collision_mask_value(6,true)
	move_and_slide()
	
func change_direction(direction):
	if direction > 0:
		foot.position = Vector2(4,25)
		hurtBox.position = Vector2(5,4)
		playerSprite.flip_h = false
	if direction < 0:
		playerSprite.flip_h = true
		hurtBox.position = Vector2(-5,4)
		foot.position = Vector2(-4,25)

func jump_state(direction):
	if is_jumping:
		if recentDirection == 0 and direction != 0:
			recentDirection = direction
		change_direction(recentDirection)
		velocity.x = recentDirection * SPEED * 0.8
		if is_on_floor():
			is_jumping = false
			state = RUN
		if velocity.y <= 0:
			playerActionAnimation.play("JumpUping")
		else:
			playerActionAnimation.play("JumpDowning")
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		recentDirection = direction
		
func move_state(direction):
	if direction:
		change_direction(direction)
		playerActionAnimation.play("Run")
		velocity.x = direction * SPEED
	else:
		playerActionAnimation.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

func hurting_state():
	if velocity == Vector2.ZERO:
		state = RUN
	velocity.x = move_toward(velocity.x, 0, FRICTION/3)
	
func attack():
	if not can_attack:
		return
	can_attack = false
	attackTimer.start(CD)
	var bomb = Bomb.instantiate()
	var world = get_tree().current_scene
	bomb.global_position = global_position + Vector2(0,-3)
	world.add_child(bomb)

func _on_hurt_box_area_entered(area:Area2D):
	if area.name == "HitBox":
		if not hurtBox.is_invincible():
			hurtBox.start_invincible()
			velocity = area.get_hit_velocity(global_position)
			state = HURTING

func _on_attack_timer_timeout():
	can_attack = true
