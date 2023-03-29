extends Node

var obj_mapper = {}

enum HurtTag {
	PLAYER,
	ENEMY,
	BOMB
}

enum HitTag {
	BLOWHIT
}

func add_obj(name,node:Node):
	obj_mapper[name] = node


func get_obj(name):
	if obj_mapper.has(name):
		return obj_mapper[name]
	return null
		

