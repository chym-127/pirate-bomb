extends Area2D

enum HurtTag {
	PLAYER,
	ENEMY,
	BOMB
}

@onready var timer = $Timer
@export var tag:HurtTag
@export var invincible_time:float = 1.0
var invincible = false



func start_invincible():
	invincible = true
	timer.start(invincible_time)

func _on_area_entered(area):
	pass # Replace with function body.

func _on_timer_timeout():
	invincible = false
	
func is_invincible():
	return invincible
