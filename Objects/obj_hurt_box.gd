extends Area2D

@export var X_FORCE = 10000
@export var Y_FORCE = -15000

func _on_area_entered(area):
	if area.name == "HitBox":
		var d_v = area.global_position.direction_to(global_position)
		var distance =  area.global_position.distance_to(global_position)
		var x = 0
		if d_v.x > 0:
			x = 1
		else:
			x = -1
		var body:RigidBody2D = get_parent()
		body.apply_force(Vector2(X_FORCE*x,Y_FORCE),Vector2(10,10))
