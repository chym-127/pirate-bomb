extends CharacterBody2D

const SPEED = 200.0
const FRICTION = 25
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var hurtBox = $HurtBox
@onready var hurtShape2D = $HurtBox/CollisionShape2D
@onready var hitBox = $HitBox
@onready var animationPlayer = $AnimationPlayer

var is_booming = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if velocity.y < 0:
		self.set_collision_layer_value(7,false)
		self.set_collision_mask_value(6,false)
	else: 
		self.set_collision_layer_value(7,true)
		self.set_collision_mask_value(6,true)
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	if not is_booming:
		move_and_slide()
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "boom" || "Idle":
		queue_free()

func start_boom():
	is_booming = true
	
func stop_boom():
	animationPlayer.stop()
	animationPlayer.play("Idle")

func _on_hurt_box_area_entered(area):
	if area.tag == MapContext.HitTag.BLOWHIT:
		self.call_deferred("stop_boom")
	if area.tag == MapContext.HitTag.ENEMYHIT:
		hurtShape2D.disabled = true
		velocity = area.get_hit_velocity(global_position) * Vector2(1.8,1.4)
