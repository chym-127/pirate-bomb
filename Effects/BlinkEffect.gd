extends Node2D

@onready var animationPlayer = $AnimationPlayer

func start_effect():
	animationPlayer.play('start')


func _on_animation_player_animation_finished(anim_name):
	pass
