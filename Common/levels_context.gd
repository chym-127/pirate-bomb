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

func set_state(enemy_count,level):
	self.level = level
	self.enemy_count = enemy_count

func enemy_death():
	self.enemy_count -= 1
	if self.enemy_count == 0:
		open_door()

func open_door():
	door_state = OPENED
	emit_signal("opendoor")
	
func next_level():
	print("next_level")

func door_is_closed():
	next_level()
	
func player_entered_door():
	emit_signal("closedoor")
	
	
	
