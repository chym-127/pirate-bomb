extends Node2D

@onready var animationPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("Closed")
	LevelsContext.connect("opendoor",Callable(self,"open"))
	LevelsContext.connect("closedoor",Callable(self,"close"))


func open():
	animationPlayer.play("Opening")

func close():
	animationPlayer.play("Closing")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	MapContext.get_obj("PLAYER").enter_door()
	print("player entered")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Closing":
		LevelsContext.door_is_closed()
