extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const FRICTION = 25

@onready var actionAnimation = $AnimationPlayer
@onready var hurtBox = $HurtBox
@onready var blinkEffectAnimation:AnimationPlayer = $BlinkEffectAnimation

enum {
	SEEK_PLAYER,
	SEEK_BOMB,
	HURT,
	HIT
}

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if hurtBox.is_invincible():
		blinkEffectAnimation.play("start")
	else:
		blinkEffectAnimation.stop()
		blinkEffectAnimation.play("RESET")
	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = 0
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		actionAnimation.play("Idle")
	velocity.x = move_toward(velocity.x, 0, FRICTION*0.3)
	move_and_slide()


func _on_hurt_box_area_entered(area):
	if area.name == "HitBox":
		if not hurtBox.is_invincible():
			hurtBox.start_invincible()
			velocity = area.get_hit_velocity(global_position)

func _on_territory_box_area_entered(area):
	if area.tag == CommonVariables.HurtTag.PLAYER:
		print("PLAYER")
	pass # Replace with function body.
