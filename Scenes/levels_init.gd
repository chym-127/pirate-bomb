extends Node2D

@onready var tileMap = $TileMap
@onready var player = $Player
@export var level = 1
@export var enemy_count = 1

#图块的自定义类型
var tileArr = [] 
var can_point_mapper = {}
var map_size = Vector2i.ZERO
var key_format = "%s-%s"

# Called when the node enters the scene tree for the first time.
func _ready():
	MapContext.add_obj("PLAYER",player)
	MapContext.add_obj("TILEMAP",tileMap)
	LevelsContext.set_state(enemy_count,level)
	
	map_size = tileMap.get_used_rect().size
	for x in range(map_size.x):
		tileArr.append([])
		for y in range(map_size.y+1):
			var cell_pos = Vector2(x, y)
			var tileData = tileMap.get_cell_tile_data(1,cell_pos)
			if tileData:
				tileArr[x].append(tileData.get_custom_data_by_layer_id(0))
			else:
				tileArr[x].append(0)
	FindPath.tileMap = tileMap
	FindPath.tileArr = tileArr
	
	for x in range(map_size.x):
		for y in range(map_size.y):
			var navigationTile = get_reachable_points(Vector2i(x,y))
			if navigationTile:
				can_point_mapper[key_format % [x, y]] = navigationTile
	
	FindPath.point_mapper = can_point_mapper
	
func get_reachable_points(point:Vector2i):
	var navigationTile = NavigationTile.new()
	navigationTile.point = point
	if (tileArr[point.x][point.y] != 0 and tileArr[point.x][point.y] != 2) or tileArr[point.x][point.y+1]<2:
		return null
	var center = Vector2i(2,1)
	var arr = []
	for x in range(5):
		arr.append([])
		for y in range(3):
			var difference = center-Vector2i(x,y)
			var temp = point-difference
			if temp.x < 0 or temp.y<0 or temp.x >= map_size.x  or temp.y>=map_size.y:
				arr[x].append(-1)
				continue
			arr[x].append(tileArr[temp.x][temp.y])
	for x in range(5):
		for y in range(2):
#			下降可到达的点
			if y == 1 and (x==1 or x== 3) and ((arr[x][y] == 0 or arr[x][y] == 2) and arr[x][y+1] == 0):
				var fall_x = point.x + (x-2)*2
				if fall_x>0 and fall_x<map_size.x:
					var fall_y = point.y + 1
					while fall_y < map_size.y:
						if tileArr[fall_x][fall_y] > 1:
							navigationTile.can_points.append(Vector2i(fall_x,fall_y-1))
							fall_y = map_size.y
						fall_y += 1
#			判断这个是否能容下玩家或敌人
			if (arr[x][y] != 0 and arr[x][y] != 2) or arr[x][y+1]<2:
				continue
			var difference = center-Vector2i(x,y)
			var temp = point-difference
			if x == 0 and y == 0 and (arr[x+1][y+1] == 0 or arr[x+1][y+1] == 2):
				navigationTile.can_points.append(temp)
			if x == 2 and y == 0 and arr[x][y+1]==2:
				navigationTile.can_points.append(temp)
			if x == 4 and y == 0 and (arr[x-1][y+1] == 0 or arr[x-1][y+1] == 2):
				navigationTile.can_points.append(temp)
			if x == 0 and y == 1 and arr[x+1][y] == 0:
				navigationTile.can_points.append(temp)
			if x == 0 and y == 5 and arr[x-1][y] == 0:
				navigationTile.can_points.append(temp)
			if y == 0 and (x==1 or x== 3):
				navigationTile.can_points.append(temp)
			if y == 1 and (x==1 or x== 3):
				navigationTile.can_points.append(temp)
				
#			
	return navigationTile
	
class NavigationTile:
	var point:Vector2i
	var can_points:Array[Vector2i]=[]
