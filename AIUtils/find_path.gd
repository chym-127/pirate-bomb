extends Node

var tileArr = null
var key_format = "%s-%s"
var tileMap = null

func path(startPoint:Vector2i,endPoint:Vector2i):
	var openList = [newA(startPoint,null,1,get_hn(startPoint,endPoint))]
	var cur:A = null;
	var closeList:Array[A] = [];
	var past_point = {}
	while (openList.size()):
		cur = openList.pop_back();
		past_point[key_format % [cur.point.x, cur.point.y]] = 1
		if (Vector2i(cur.point) == endPoint):
			break;
		closeList.append(cur);
		var arr = tileMap.get_surrounding_cells(Vector2i(cur.point))
		var neighborA = get_neighbor_A(arr,cur,endPoint,past_point)
		if neighborA.size():
			openList.append_array(neighborA)
		openList.sort_custom(func(a, b): return b.fn > a.fn)
	for item in closeList:
		print(item.point)


func get_neighbor_A(arr:Array[Vector2i],parent:A,endPoint,past_point):
	var a_arr:Array[A] = []
	var r_point = arr[0]
	var d_point = arr[1]
	var l_point = arr[2]
	var u_point = parent.point
	if not past_point.has(key_format % [r_point.x, r_point.y]) and tileArr[r_point.x][r_point.y] != 1:
		a_arr.append(newA(r_point,parent,parent.gn + 1,get_hn(Vector2(r_point),endPoint)))
	if not past_point.has(key_format % [l_point.x, l_point.y]) and tileArr[l_point.x][l_point.y] != 1:
		a_arr.append(newA(l_point,parent,parent.gn + 1,get_hn(Vector2(l_point),endPoint)))
	if not past_point.has(key_format % [u_point.x, u_point.y]) and tileArr[u_point.x][u_point.y] == 2:
		a_arr.append(newA(u_point,parent,parent.gn + 1,get_hn(Vector2(u_point),endPoint)))
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
	var point = Vector2.ZERO
	var parent = null
	var gn = 0
	var hn = 0
	var fn = 0
	
