extends Node2D

@onready var tileMap = $WallAndRoad
# Called when the node enters the scene tree for the first time.
func _ready():
	var tileData = tileMap.get_cell_tile_data(1,Vector2(0,0))
	print(tileData.get_custom_data_by_layer_id(0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
