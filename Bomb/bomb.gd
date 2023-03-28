extends CharacterBody2D

const SPEED = 200.0
const FRICTION = 25
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var hurtBox = $HurtBox
@onready var hitBox = $HitBox


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
	if not is_booming:
		move_and_slide()



func _on_animation_player_animation_finished(anim_name):
	queue_free()

func hit(area:Area2D,position):
	var x_speed = SPEED
	var y_speed = JUMP_VELOCITY*0.7
	var d_v = area.global_position.direction_to(position)
	if d_v.x<0:
		x_speed *= -1
	if d_v.y<0:
		y_speed *= -1
	return Vector2(x_speed,y_speed)

func start_boom():
	is_booming = true

func _on_hurt_box_area_entered(area):
	if area.name == "HitBox":
		velocity = hitBox.get_hit_velocity(hurtBox.global_position)
		print(velocity)
