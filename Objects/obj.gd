extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state:PhysicsDirectBodyState2D):
	pass


func _on_hurt_box_area_entered(area):
	if area.name == "BombHitBox":
		var d_v = area.global_position.direction_to(global_position)
		var distance =  area.global_position.distance_to(global_position)
		var x = 0
		if d_v.x > 0:
			x = 1
		else:
			x = -1
		apply_central_force(Vector2(10000*x,-15000))
