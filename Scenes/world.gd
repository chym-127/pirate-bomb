extends Node2D

@onready var tileMap = $WallAndRoad
@onready var player = $Player
@onready var cucumber = $Cucumber

#图块的自定义类型
var tileArr = [] 

# Called when the node enters the scene tree for the first time.
func _ready():
	MapContext.add_obj("PLAYER",player)
	MapContext.add_obj("TILEMAP",tileMap)
	MapContext.add_obj("CUCUBER",cucumber)
	
	var map_size = tileMap.get_used_rect().size
	for x in range(map_size.x):
		tileArr.append([])
		for y in range(map_size.y):
			var cell_pos = Vector2(x, y)
			var tileData = tileMap.get_cell_tile_data(1,cell_pos)
			if tileData:
				tileArr[x].append(tileData.get_custom_data_by_layer_id(0))
			else:
				tileArr[x].append(0)
	
	FindPath.tileMap = tileMap
	FindPath.tileArr = tileArr
	
	
	
	
