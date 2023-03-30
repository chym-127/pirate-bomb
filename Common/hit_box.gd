extends Area2D

enum HitTag {
	BOMBHIT,
	BLOWHIT,
	ENEMYHIT
}


@export var X_SPEED = 200.0
@export var Y_SPEED = -400.0

@export var tag:HitTag

func get_hit_velocity(position):
	var x_speed = X_SPEED*0.8
	var y_speed = Y_SPEED*0.7
	var d_v = get_parent().global_position.direction_to(position)
	if d_v.x<=0:
		x_speed *= -1
	return Vector2(x_speed,y_speed)
