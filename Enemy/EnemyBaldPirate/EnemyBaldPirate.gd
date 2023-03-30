extends CharacterBody2D


const SPEED = 140.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const FRICTION = 25

@onready var actionAnimation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hitBox = $HitBox
@onready var hurtBox = $HurtBox
@onready var blinkEffectAnimation:AnimationPlayer = $BlinkEffectAnimation
@onready var stats = $stats
enum {
	SEEK_PLAYER,
	SEEK_BOMB,
	HURT,
	HIT,
	IDLE,
	DEATH
}
var state = IDLE
var d_v = Vector2.ZERO
var can_see_player = false
var can_see_bomb = false

var player = null
var tileMap = null
var seek_path = []
var bomb = null

func _ready():
	stats.connect("no_hearth",Callable(self, "death"))

func _physics_process(delta):
	if state == DEATH:
		return
	common(delta)
	if state != HIT:
		if can_see_player:
			state = SEEK_PLAYER
		if can_see_bomb:
			state = SEEK_BOMB
		if not can_see_player and not can_see_bomb:
			state = IDLE
		match state:
			SEEK_PLAYER:
				seek_player_state()
			SEEK_BOMB:
				seek_bomb_state()
			IDLE:
				d_v.x = 0
				velocity.x = 0
		if d_v and d_v.x:
			actionAnimation.play("Run")
			velocity.x = d_v.x * SPEED
		else:
			actionAnimation.play("Idle")
			velocity.x = move_toward(velocity.x, 0, FRICTION*1.3)
			
	if state == HIT:
		velocity = Vector2.ZERO
		if MapContext.get_obj("PLAYER"):
			var d = global_position.direction_to(MapContext.get_obj("PLAYER").global_position)
			change_direction(d.x)
		actionAnimation.play("Hit")
		
	change_direction(d_v.x)
	move_and_slide()

func death():
	state = DEATH
	actionAnimation.play("Death")

func seek_bomb_state():
	var startPoint = MapContext.get_obj("TILEMAP").local_to_map(global_position)
	var endPoint = MapContext.get_obj("TILEMAP").local_to_map(bomb.global_position)
	if startPoint.y == endPoint.y:
		var data = FindPath.seek_target(self,bomb,16,d_v)
		if data[1]:
			state = HIT
		else:
			d_v = data[0]
				
func seek_player_state():
	var data = FindPath.seek_target(self,MapContext.get_obj("PLAYER"),16,d_v)
	if data[1]:
		state = HIT
	else:
		d_v = data[0]
		if d_v.y < 0 and is_on_floor():
			jump()
			d_v.y = 0

func jump():
	velocity.y = JUMP_VELOCITY

func change_direction(direction):
	if direction > 0:
		sprite.flip_h = true
		hitBox.position = Vector2(2,22)
		hitBox.rotation = 70.0
	if direction < 0:
		hitBox.position = Vector2(-2,23)
		hitBox.rotation = 106
		sprite.flip_h = false

func common(delta):
	if velocity.y < 0:
		self.set_collision_layer_value(7,false)
		self.set_collision_mask_value(6,false)
	else: 
		self.set_collision_layer_value(7,true)
		self.set_collision_mask_value(6,true)
	if not is_on_floor():
		velocity.y += gravity * delta
	if hurtBox.is_invincible():
		blinkEffectAnimation.play("start")
	else:
		blinkEffectAnimation.stop()
		blinkEffectAnimation.play("RESET")
	
func seek_bomb():
	if MapContext.get_obj("TILEMAP"):
		var startPoint = MapContext.get_obj("TILEMAP").local_to_map(global_position)
		var endPoint = MapContext.get_obj("TILEMAP").local_to_map(bomb.global_position)
		seek_path = FindPath.path(startPoint,endPoint)
	
func seek_player():
	if MapContext.get_obj("TILEMAP"):
		var startPoint = MapContext.get_obj("TILEMAP").local_to_map(global_position)
		var endPoint = MapContext.get_obj("TILEMAP").local_to_map(MapContext.get_obj("PLAYER").global_position)
		seek_path = FindPath.path(startPoint,endPoint)

func _on_hurt_box_area_entered(area):
	if area.name == "HitBox":
		if not hurtBox.is_invincible():
			hurtBox.start_invincible()
			stats.hearth -= 1
			velocity = area.get_hit_velocity(global_position)

func _on_territory_box_area_entered(area):
	if area.tag == MapContext.HurtTag.PLAYER:
		can_see_player = true
	if area.tag == MapContext.HurtTag.BOMB:
		can_see_bomb = true
		bomb = area.get_parent()
	pass # Replace with function body.


func _on_territory_box_area_exited(area):
	if area.tag == MapContext.HurtTag.PLAYER:
		can_see_player = false
	if area.tag == MapContext.HurtTag.BOMB:
		can_see_bomb = false
		bomb = null
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Hit":
		state = IDLE
	if anim_name == "Death":
		queue_free()
