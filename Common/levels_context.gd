extends Node


signal opendoor
signal closedoor


enum {
	CLOSED,
	OPENED,
}

var enemy_count = 3
var door_state = CLOSED
var level = 1
var next_level_scene = null

var level_format = "res://Scenes/level_{index}.tscn"


func set_state(enemy_count,level):
	self.level = level
	self.enemy_count = enemy_count
	var str = level_format.format([["index",level+1]])
	next_level_scene = load(str)

func enemy_death():
	self.enemy_count -= 1
	if self.enemy_count == 0:
		open_door()

func open_door():
	door_state = OPENED
	emit_signal("opendoor")
	
func next_level():
	if next_level_scene:
		get_tree().change_scene_to_packed(next_level_scene)

func door_is_closed():
	next_level()
	
func player_entered_door():
	emit_signal("closedoor")
	
	
	
