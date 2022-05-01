extends Node


func _ready():
	var a = Global.data.hex.a * Global.data.scale
	Global.node.TileMapHex.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapSquare90.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapSquare90.position.x = a / 2
	Global.node.TileMapSquare90.position.y = a * sqrt(3)
	Global.node.TileMapSquare150.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapSquare150.position.x = a * 1.5
	Global.node.TileMapSquare150.position.y = a * sqrt(3)/2
	Global.node.TileMapSquare30.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapSquare30.position.x = -a * sqrt(3)/2 + 2 * Global.data.scale
	Global.node.TileMapSquare30.position.y = a * sqrt(3)/2 + 1 * Global.data.scale
	Global.node.TileMapTriangle180.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapTriangle180.position.x = a * (sqrt(3) + 1)/2 - 1 * Global.data.scale
	Global.node.TileMapTriangle180.position.y = a * sqrt(3) - 2 * Global.data.scale
	Global.node.TileMapTriangle0.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapTriangle0.position.x = a * (-sqrt(3) + 1)/2 + 1 * Global.data.scale
	Global.node.TileMapTriangle0.position.y = a * sqrt(3) - 2 * Global.data.scale
	
	
	for _y in Global.data.size.map.y:
		Global.array.hex.append([])
		Global.array.square150.append([])
		Global.array.square90.append([])
		Global.array.square30.append([])
		Global.array.triangle0.append([])
		Global.array.triangle180.append([])
	
		for _x in Global.data.size.map.x:
			var index = (_y * Global.data.size.map.x + _x) * 6
			var flag = {}
			flag.TileMapHex = false
			flag.TileMapSquare30 = false
			flag.TileMapSquare90 = false
			flag.TileMapSquare150 = false
			flag.TileMapTriangle180 = false
			flag.TileMapTriangle0 = false
#			if _x == 0:
#				flag.TileMapSquare30 = false
#				flag.TileMapTriangle0 = false
#
#			if _x == m-1:
#				flag.TileMapSquare150 = false
#				flag.TileMapTriangle180 = false
#
#
#			if _y == n-1 && _x %2 == 1:
#				flag.TileMapTriangle0 = false
#				flag.TileMapTriangle180 = false
#				flag.TileMapSquare90 = false
			
			var input = {}
			input.grid = Vector2(_x,_y)
			input.visiable = false
			input.index = index
			input.edges = "6"
			input.parent = Global.node.TileMapHex
			var tile = Classes.Tile.new(input)
			Global.array.hex[_y].append(tile)
			
			input.edges = "4"
			input.index = index + 1
			input.parent = Global.node.TileMapSquare150
			tile = Classes.Tile.new(input)
			Global.array.square150[_y].append(tile)
			
			input.index = index + 3
			input.parent = Global.node.TileMapSquare90
			tile = Classes.Tile.new(input)
			Global.array.square90[_y].append(tile)
			
			input.index = index + 5
			input.parent = Global.node.TileMapSquare30
			tile = Classes.Tile.new(input)
			Global.array.square30[_y].append(tile)
#
#			Global.node.TileMapSquare90.set_cell(_x,_y,_i)
#
#			if _x != 0:
#				Global.node.TileMapSquare30.set_cell(_x,_y,_i)
#				if _y != n-1:
#					Global.node.TileMapTriangle0.set_cell(_x,_y,_i) 
##				else: 
##					if _x%2 != 1:
##						Global.node.TileMapTriangle0.set_cell(_x,_y,_i)
#				if _y != n-1:
#
#					Global.node.TileMapTriangle180.set_cell(_x,_y,_i) 
##				else: 
##					if _x%2 != 1:
##						Global.node.TileMapTriangle180.set_cell(_x,_y,_i)
	
	around_center()
	
	for _y in Global.data.size.map.y:
		for _x in Global.data.size.map.x:
			var _i = (Global.array.hex[_y][_x].number.ring) % 8
			
			if Global.array.hex[_y][_x].flag.visiable:
				Global.node.TileMapHex.set_cell(_x,_y,_i) 
			if Global.array.square30[_y][_x].flag.visiable:
				Global.node.TileMapSquare30.set_cell(_x,_y,_i) 
			if Global.array.square90[_y][_x].flag.visiable:
				Global.node.TileMapSquare90.set_cell(_x,_y,_i) 
			if Global.array.square150[_y][_x].flag.visiable:
				Global.node.TileMapSquare150.set_cell(_x,_y,_i) 
#			if flag.TileMapTriangle180:
#				Global.node.TileMapTriangle180.set_cell(_x,_y,_i) 
#			if flag.TileMapTriangle0:
#				Global.node.TileMapTriangle0.set_cell(_x,_y,_i) 

func bubble_sort(arr_, key_):
	for _i in arr_.size() - 1:
		var flag = false
		
		for _j in arr_.size() - 1 - _i:
			if arr_[_j][key_] > arr_[_j + 1][key_]:
				var temp = arr_[_j][key_]
				arr_[_j][key_] = arr_[_j + 1][key_]
				arr_[_j + 1][key_] = temp
				flag = true
		
		if !flag:
			break
	
	return arr_


func around_center():
	var core = Global.array.hex[Global.data.size.n][Global.data.size.n]
	var arounds = [ core ]
	core.number.ring = 0
	
	for _i in Global.data.size.n:
		for _j in range(arounds.size()-1,-1,-1):
			var parity = int(arounds[_j].vector.grid.x) % 2
			
			for neighbor in Global.array.neighbor[parity]:
				var grid = arounds[_j].vector.grid + neighbor 
				
				if check_border(grid):
					var around = Global.array.hex[grid.y][grid.x]
					
					if !arounds.has(around):
						arounds.append(around)
						around.number.ring = ( _i + 1 ) * 2
	
	for around in arounds:
		around.flag.visiable = true
		
		var squares = []
	
		var parity = int(core.vector.grid.x) % 2
		var grid = around.vector.grid 
		
		if check_border(grid):
			squares.append(Global.array.square150[grid.y][grid.x])
			squares.append(Global.array.square90[grid.y][grid.x])
			squares.append(Global.array.square30[grid.y][grid.x])
		grid = around.vector.grid + Global.array.neighbor[parity][4]
		
		if check_border(grid):
			squares.append(Global.array.square150[grid.y][grid.x])
		grid = around.vector.grid + Global.array.neighbor[parity][5]
		
		if check_border(grid):
			squares.append(Global.array.square90[grid.y][grid.x])
		grid = around.vector.grid + Global.array.neighbor[parity][0]
		
		if check_border(grid):
			squares.append(Global.array.square30[grid.y][grid.x])
		around.list.neighbor["4"] = squares
		
		for square in squares:
			square.list.neighbor["6"].append(around)
	
	
#	if check_border(grid):
#		var square = Global.array.square90[grid.y][grid.x]
			
	
	for _y in Global.data.size.map.y:
		for _x in Global.data.size.map.x:
			if Global.array.square150[_y][_x].list.neighbor["6"].size() > 0:
				Global.array.square150[_y][_x].flag.visiable = true
			if Global.array.square90[_y][_x].list.neighbor["6"].size() > 0:
				Global.array.square90[_y][_x].flag.visiable = true
			if Global.array.square30[_y][_x].list.neighbor["6"].size() > 0:
				Global.array.square30[_y][_x].flag.visiable = true
	

func check_border(grid_):
	var flag = ( grid_.x >= Global.data.size.map.x ) || ( grid_.x < 0 ) || ( grid_.y >= Global.data.size.map.y ) || ( grid_.y < 0 )
	return !flag

func _process(delta):
	pass

func _on_Timer_timeout():
	Global.node.TimeBar.value +=1
	
	if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
		Global.node.TimeBar.value -= Global.node.TimeBar.max_value
