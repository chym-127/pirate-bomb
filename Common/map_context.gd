extends Node

var obj_mapper = {}

enum OBJ {
	PLAYER
}

func add_obj(name,node:Node):
	obj_mapper[name] = node


func get_obj(name):
	if obj_mapper.has(name):
		return obj_mapper[name]
	return null
		

