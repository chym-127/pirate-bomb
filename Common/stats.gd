extends Node

@export var MAX_HEARTH:int = 3

signal no_hearth

@onready var hearth = MAX_HEARTH:
	set(val):
		hearth = val
		if hearth == 0:
			emit_signal("no_hearth")
		
