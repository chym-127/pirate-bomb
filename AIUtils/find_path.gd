extends Node

var tileArr = null
var key_format = "%s-%s"
var point_mapper = {}
var tileMap = null
var cell_size = 64

#寻找目标
func seek_target(current_node:CharacterBody2D,target_node:CharacterBody2D,offset:int,d_v:Vector2):
	var found = false
	if target_node and current_node and current_node.is_on_floor():
		var startPoint = MapContext.get_obj("TILEMAP").local_to_map(current_node.global_position)
		var endPoint = MapContext.get_obj("TILEMAP").local_to_map(target_node.global_position)
		if not target_node.is_on_floor():
			var land_point = get_landing_point(endPoint)
			if land_point:
				endPoint = land_point
		if startPoint == endPoint:
			if abs(current_node.global_position.x - target_node.global_position.x) > offset:
				var x = current_node.global_position.direction_to(target_node.global_position).x
				if x > 0:
					d_v.x = 1
				if x < 0:
					d_v.x = -1
			else:
				d_v = Vector2.ZERO
				found = true
		else:
			if tileArr[startPoint.x][startPoint.y+1] == 0:
				startPoint.x = startPoint.x - d_v.x
			var seek_path = FindPath.path(startPoint,endPoint)
			if seek_path and seek_path.size():
				d_v = get_action(seek_path,startPoint,current_node.global_position)
	return [d_v,found]

func get_landing_point(nowPoint:Vector2):
	var c_y = nowPoint.y
	var t_y = MapContext.get_obj("TILEMAP").get_used_rect().size.y
	while c_y <= t_y:
		if tileArr[nowPoint.x][c_y] > 1:
			return Vector2i(nowPoint.x,c_y)
		c_y += 1
	return Vector2i.ZERO


func path(startPoint:Vector2i,endPoint:Vector2i):
	if not point_mapper.has(key_format % [endPoint.x, endPoint.y]):
		return
	var openList = [newA(startPoint,null,1,get_hn(startPoint,endPoint))]
	var cur:A = null;
	var closeList:Array[A] = [];
	var past_point = {}
	var found = false
	while (openList.size()):
		cur = openList.pop_back();
		past_point[key_format % [cur.point.x, cur.point.y]] = 1
		if (Vector2i(cur.point) == endPoint):
			found = true
			break;
		closeList.append(cur);
		var neighborA = get_neighbor_A(cur,endPoint,past_point)
		if neighborA.size():
			openList.append_array(neighborA)
		openList.sort_custom(func(a, b): return b.fn < a.fn)
	var path:Array[Vector2] = []
	if found:
		while cur:
			path.append(cur.point)
			cur = cur.parent
		path.reverse()
	else:
		path.append(Vector2(startPoint))
		if endPoint.x<startPoint.x:
			path.append(Vector2(startPoint.x-1,startPoint.y))
		if endPoint.x>startPoint.x: 
			path.append(Vector2(startPoint.x+1,startPoint.y))
	return path
	
func get_action(seek_path:Array[Vector2],current_point,global_position):
#	var current_point = MapContext.get_obj("TILEMAP").local_to_map(global_position)
	var len = seek_path.size()
	var next_point = null
	var d_v = Vector2.ZERO
	for index in range(len):
		if index<len-1 and Vector2(current_point) == seek_path[index]:
			next_point = seek_path[index+1]
	if next_point:
		d_v = Vector2(current_point).direction_to(next_point)
		var d = Vector2(current_point).distance_to(next_point)
		if d_v.x > 0:
			d_v.x = 1
		if d_v.x < 0:
			d_v.x = -1
		var jump_positon = (current_point.x+1)*cell_size - (cell_size/2)
		if d_v.y < 0 and d > 2:
			if d_v.x > 0 and jump_positon > global_position.x:
				d_v.y = 0
			if d_v.x < 0  and jump_positon < global_position.x:
				d_v.y = 0
		return d_v
	return Vector2.ZERO
	
func get_neighbor_A(parent:A,endPoint,past_point):
	var a_arr:Array[A] = []
	if point_mapper.has(key_format % [parent.point.x, parent.point.y]):
		var can_points = point_mapper[key_format % [parent.point.x, parent.point.y]].can_points
		for point in can_points:
			if not past_point.has(key_format % [point.x, point.y]):
				a_arr.append(newA(point,parent,parent.gn + 1,get_hn(Vector2(point),endPoint)))
	a_arr.sort_custom(func(a, b): return b.fn > a.fn)
	return a_arr

#    获取当前节点到目标节点的预估距离，使用曼哈顿距离
func get_hn(point:Vector2,otherPoint:Vector2):
	return point.distance_to(otherPoint)


func newA(point:Vector2,parent,gn:int,hn:int):
	var instance = A.new()
	instance.point = point
	instance.parent = parent
	instance.gn = gn
	instance.hn = hn
	instance.fn = gn + hn
	return instance

class A:
	var point:Vector2 = Vector2.ZERO
	var parent = null
	var gn = 0
	var hn = 0
	var fn = 0
	
