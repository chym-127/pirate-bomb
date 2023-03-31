extends Node2D

var l_1 = preload("res://Scenes/level_1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#开始游戏
func _on_button_pressed():
	get_tree().change_scene_to_packed(l_1)
