extends Node


func _ready():
	init_maps()
	around_center()
	init_rings()
	init_terrains()
	
	paint_maps()

func _process(delta):
	pass

func init_maps():
	var a = Global.data.hex.a * Global.data.scale
	var x = (Global.data.size.n + 0.5) * Global.node.TileMapHex.cell_size.x * Global.data.scale
	var y = (Global.data.size.n + 1) * Global.node.TileMapHex.cell_size.y * Global.data.scale
	var offset = -Vector2(x, y) + Global.data.size.window.center 
	Global.node.TileMapHex.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapHex.position.x = offset.x
	Global.node.TileMapHex.position.y = offset.y
	Global.node.TileMapSquare90.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapSquare90.position.x = offset.x + a / 2
	Global.node.TileMapSquare90.position.y = offset.y + a * sqrt(3)
	Global.node.TileMapSquare150.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapSquare150.position.x = offset.x + a * 1.5
	Global.node.TileMapSquare150.position.y = offset.y + a * sqrt(3)/2
	Global.node.TileMapSquare30.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapSquare30.position.x = offset.x + -a * sqrt(3)/2 + 2 * Global.data.scale
	Global.node.TileMapSquare30.position.y = offset.y + a * sqrt(3)/2 + 1 * Global.data.scale
	Global.node.TileMapTriangle180.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapTriangle180.position.x = offset.x + a * (sqrt(3) + 1)/2 - 1 * Global.data.scale
	Global.node.TileMapTriangle180.position.y = offset.y + a * sqrt(3) - 2 * Global.data.scale
	Global.node.TileMapTriangle0.scale = Vector2(Global.data.scale, Global.data.scale)
	Global.node.TileMapTriangle0.position.x = offset.x + a * (-sqrt(3) + 1)/2 + 1 * Global.data.scale
	Global.node.TileMapTriangle0.position.y = offset.y + a * sqrt(3) - 2 * Global.data.scale
	
	for _y in Global.data.size.map.y:
		Global.array.hex.append([])
		Global.array.square150.append([])
		Global.array.square90.append([])
		Global.array.square30.append([])
		Global.array.triangle0.append([])
		Global.array.triangle180.append([])
	
		for _x in Global.data.size.map.x:
			var index = (_y * Global.data.size.map.x + _x) * 6
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
			
			input.edges = "3"
			input.index = index + 2
			input.parent = Global.node.TileMapTriangle180
			tile = Classes.Tile.new(input)
			Global.array.triangle180[_y].append(tile)
			
			input.index = index + 4
			input.parent = Global.node.TileMapTriangle0
			tile = Classes.Tile.new(input)
			Global.array.triangle0[_y].append(tile)

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
		var parity = int(around.vector.grid.x) % 2
		
		for neighbor in Global.array.neighbor[parity]:
			var grid = around.vector.grid + neighbor 
			
			if check_border(grid):
				around.array.hex.append(Global.array.hex[grid.y][grid.x])
			
		var squares = []
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
		
		
		grid = around.vector.grid 
		var triangle = Global.array.triangle180[grid.y][grid.x]
		squares = []
		
		squares.append(Global.array.square150[grid.y][grid.x])
		squares.append(Global.array.square90[grid.y][grid.x])
		
		grid = around.vector.grid + Global.array.neighbor[parity][1]
		
		if check_border(grid):
			squares.append(Global.array.square30[grid.y][grid.x])
			
		for square in squares:
			square.list.neighbor["3"].append(triangle)
			triangle.list.neighbor["4"].append(square)
		
		grid = around.vector.grid 
		triangle = Global.array.triangle0[grid.y][grid.x]
		squares = []
		
		squares.append(Global.array.square90[grid.y][grid.x])
		squares.append(Global.array.square30[grid.y][grid.x])
		
		grid = around.vector.grid + Global.array.neighbor[parity][3]
		
		if check_border(grid):
			squares.append(Global.array.square150[grid.y][grid.x])
		
		for square in squares:
			square.list.neighbor["3"].append(triangle)
			triangle.list.neighbor["4"].append(square)

func init_rings():
	for _y in Global.data.size.map.y:
		for _x in Global.data.size.map.x:
			Global.array.square150[_y][_x].set_ring_gate()
			Global.array.square90[_y][_x].set_ring_gate()
			Global.array.square30[_y][_x].set_ring_gate()
	
	var ring = 0
	
	while ring < Global.data.size.rings:
		var hexs = []
		
		for _y in Global.data.size.map.y:
			for _x in Global.data.size.map.x:
				if Global.array.hex[_y][_x].number.ring == ring:
					hexs.append(Global.array.hex[_y][_x])
		
		var squares = []
		
		for hex in hexs:
			for square in hex.list.neighbor["4"]:
				if square.number.ring == -1:
					squares.append(square)
					
		for square in squares:
			square.number.ring = ring + 1
		
			var triangles = square.list.neighbor["3"]
			
			for triangle in triangles:
				triangle.number.ring = ring + 1
				
		ring += 2
	
	for _y in Global.data.size.map.y:
		for _x in Global.data.size.map.x:
			Global.array.square150[_y][_x].flag.visiable = Global.array.square150[_y][_x].number.ring != -1
			Global.array.square90[_y][_x].flag.visiable = Global.array.square90[_y][_x].number.ring != -1
			Global.array.square30[_y][_x].flag.visiable = Global.array.square30[_y][_x].number.ring != -1
			Global.array.triangle180[_y][_x].flag.visiable = Global.array.triangle180[_y][_x].number.ring != -1
			Global.array.triangle0[_y][_x].flag.visiable = Global.array.triangle0[_y][_x].number.ring != -1
			
			if !Global.array.hex[_y][_x].flag.visiable:
				var neighbors = Global.array.hex[_y][_x].get_neighbors()
				
				for neighbor in neighbors:
					neighbor.list.neighbor["6"].erase(Global.array.hex[_y][_x])
					
			
			if !Global.array.square150[_y][_x].flag.visiable:
				var neighbors = Global.array.square150[_y][_x].get_neighbors()
				
				for neighbor in neighbors:
					neighbor.list.neighbor["4"].erase(Global.array.square150[_y][_x])
					
			
			if !Global.array.square90[_y][_x].flag.visiable:
				var neighbors = Global.array.square90[_y][_x].get_neighbors()
				
				for neighbor in neighbors:
					neighbor.list.neighbor["4"].erase(Global.array.square90[_y][_x])
					
			
			if !Global.array.square30[_y][_x].flag.visiable:
				var neighbors = Global.array.square30[_y][_x].get_neighbors()
				
				for neighbor in neighbors:
					neighbor.list.neighbor["4"].erase(Global.array.square30[_y][_x])
					
			
			if !Global.array.triangle180[_y][_x].flag.visiable:
				var neighbors = Global.array.triangle180[_y][_x].get_neighbors()
				
				for neighbor in neighbors:
					neighbor.list.neighbor["3"].erase(Global.array.triangle180[_y][_x])
					
			
			if !Global.array.triangle0[_y][_x].flag.visiable:
				var neighbors = Global.array.triangle0[_y][_x].get_neighbors()
				
				for neighbor in neighbors:
					neighbor.list.neighbor["3"].erase(Global.array.triangle0[_y][_x])

func init_terrains():
	init_mountains()
	init_regions_after_mountain()
	init_rivers()
	init_polars()

func init_mountains():
	#find start hex
	var options = []
	
	for _y in Global.data.size.map.y:
		for _x in Global.data.size.map.x:
			if Global.array.hex[_y][_x].number.ring == Global.data.size.rings:
				options.append(Global.array.hex[_y][_x])
	
	Global.rng.randomize()
	var index_r = Global.rng.randi_range(0, options.size() - 1)
	#init original mountain
	var original_mountains = [options[index_r]]
	var parity = int(original_mountains[0].vector.grid.x) % 2
	
	for neighbor in Global.array.neighbor[parity]:
		var grid = original_mountains[0].vector.grid + neighbor

		if check_border(grid):
			if Global.array.hex[grid.y][grid.x].number.ring == Global.data.size.rings:
				original_mountains.append(Global.array.hex[grid.y][grid.x])
	
	var original_elements = []
	Global.rng.randomize()
	index_r = Global.rng.randi_range(0, original_mountains.size() - 1)
	original_elements.append(original_mountains[index_r])
	
	#init reflected mountain
	var shift = original_mountains[0].vector.grid - Vector2(Global.data.size.n, Global.data.size.n)
	var reflection = Vector2(Global.data.size.n, Global.data.size.n) - shift
	
	if parity == 0:
		reflection.y += 1
	
	var reflected_mountains = [Global.array.hex[reflection.y][reflection.x]]
	parity = int(reflected_mountains[0].vector.grid.x) % 2
	
	for neighbor in Global.array.neighbor[parity]:
		var grid = reflected_mountains[0].vector.grid + neighbor

		if check_border(grid):
			if Global.array.hex[grid.y][grid.x].number.ring == Global.data.size.rings:
				reflected_mountains.append(Global.array.hex[grid.y][grid.x])
		
	var reflected_elements = []
	Global.rng.randomize()
	index_r = Global.rng.randi_range(0, reflected_mountains.size() - 1)
	reflected_elements.append(reflected_mountains[index_r])
	
	var d = reflected_elements.back().vector.grid.distance_to(original_elements.back().vector.grid)
	var gate_size = 1
	
	while d > gate_size:
		#procure original mountain
		options = []
		parity = int(original_elements.back().vector.grid.x) % 2
		
		for neighbor in Global.array.neighbor[parity]:
			var grid = original_elements.back().vector.grid + neighbor
			
			if check_border(grid):
				var hex = Global.array.hex[grid.y][grid.x]
				
				if hex.flag.visiable:
					if !original_elements.has(hex) && !reflected_elements.has(hex):
						var d_ = reflected_elements.back().vector.grid.distance_to(grid)
						
						if d >= d_:
							for _i in (d - d_) * 2 + 1:
								options.append(hex)
		
		Global.rng.randomize()
		index_r = Global.rng.randi_range(0, options.size() - 1)
		original_elements.append(options[index_r])
		
		d = original_elements.back().vector.grid.distance_to(reflected_elements.back().vector.grid)
	
		#procure reflected mountain
		if d > gate_size:
			options = []
			parity = int(reflected_elements.back().vector.grid.x) % 2
			
			for neighbor in Global.array.neighbor[parity]:
				var grid = reflected_elements.back().vector.grid + neighbor
				
				if check_border(grid):
					var hex = Global.array.hex[grid.y][grid.x]
					
					if hex.flag.visiable:
						if !original_elements.has(hex) && !reflected_elements.has(hex):
							var d_ = original_elements.back().vector.grid.distance_to(grid)
							
							if d >= d_:
								for _i in (d - d_) * 2 + 1:
									options.append(hex)
			
			Global.rng.randomize()
			index_r = Global.rng.randi_range(0, options.size() - 1)
			reflected_elements.append(options[index_r])
		
		d = reflected_elements.back().vector.grid.distance_to(original_elements.back().vector.grid)
	
	#make gate
	options = []
	for _i in original_elements.size():
		options.append("original")
		
	for _i in reflected_elements.size():
		options.append("reflected")
	
	Global.rng.randomize()
	index_r = Global.rng.randi_range(0, options.size() - 1)
	
	for original_element in original_elements:
		Global.list.terrain.mountain.append(original_element)
	for reflected_element in reflected_elements:
		Global.list.terrain.mountain.append(reflected_element)
	for hex in Global.list.terrain.mountain:
		hex.set_terrain(2)

func init_regions_after_mountain():
	var unfilled = []
	var filleds = []
	var borderline = []
	
	for _y in Global.data.size.map.y:
		for _x in Global.data.size.map.x: 
			var hex = Global.array.hex[_y][_x]
			
			if hex.flag.visiable && hex.number.terrain == -1:
				unfilled.append(hex)
	
	while unfilled.size() > 0:
		Global.rng.randomize()
		var index_r = Global.rng.randi_range(0, unfilled.size() - 1)
		filleds.append([unfilled.pop_at(index_r)])
		var flag = true
		
		while flag || borderline.size() > 0: 
			flag = false
			
			filleds.back().append_array(borderline)
			borderline = []
		
			for filled in filleds.back():
				for hex in filled.array.hex:
					if unfilled.has(hex) && !borderline.has(hex):  
						borderline.append(hex)
						unfilled.erase(hex)
	
	Global.array.region = filleds
	
	for _i in filleds.size():
		for hex in filleds[_i]:
			hex.set_terrain(_i+5)

func init_rivers():
	var region_centers = []
	
	for region in Global.array.region:
		var center = Vector2()
		for hex in region:
			center += hex.vector.grid
		
		center /= region.size()
		region_centers.append(center)
		Global.array.hex[int(round(center.y))][int(round(center.x))].set_terrain(4)
	
		var steps = [[0,0],[0,1],[1,0],[1,1],[1,2],[2,1],[2,2],[2,3],[3,2],[3,3],[3,4],[4,3],[4,4],[4,5],[5,4],[5,5],[5,0],[0,5]]
		var stops = []
		var grids = []
		var parity = int(round(center.x)) % 2
		
		for _i in steps.size():
			stops.append(false)
			grids.append(Vector2(int(round(center.x)),int(round(center.y))))
			
			while !stops[_i]:
				for step in steps[_i]:
					if !stops[_i]:
						grids[_i] += Global.array.neighbor[parity][step]
						
						if check_border(grids[_i]):
							if Global.array.hex[grids[_i].y][grids[_i].x].string.terrain == "Mountain":
								grids[_i] -= Global.array.neighbor[parity][step]
								stops[_i] = true
							if !Global.array.hex[grids[_i].y][grids[_i].x].flag.visiable:
								stops[_i] = true
								grids[_i] = Vector2(0,0)
						else:
							stops[_i] = true
							grids[_i] = Vector2(0,0)
					
		var options = []
		
		for _i in grids.size():
			var grid = grids[_i]
			
			if grid != Vector2() && !options.has(grid):
				var flag = false
				
				for hex in Global.array.hex[grid.y][grid.x].array.hex:
					if hex.string.terrain == "Mountain":
						flag = true
				
				if flag:
					var d = grid.distance_squared_to(center)
					var option = {
						"grid": grid,
						"d": d,
						"steps": steps[_i]
					}
					options.append(option)
		
		bubble_sort(options, "d")
		var start = Global.array.hex[options.back()["grid"].y][options.back()["grid"].x]
		var river = [start]
		
		print()
		
#		parity = int(round(start.vector.grid.x)) % 2
#		var best_move = -1
#		var d = start.vector.grid.distance_squared_to(center)
#
#		for _i in Global.array.neighbor[parity].size():
#			var grid_ = start.vector.grid + Global.array.neighbor[parity][_i]
#
#			if check_border(grid_):
#				var hex = Global.array.hex[grid_.y][grid_.x]
#
#				if hex.flag.visiable:
#					var d_ = grid_.distance_squared_to(center)
#
#					if d >= d_:
#						best_move = _i
#						d = d_
#
#		var moves = []
#
#		for _i in range(-1,2):
#			var _j = (_i + best_move + Global.array.neighbor[parity].size()) % Global.array.neighbor[parity].size()
#			moves.append(Global.array.neighbor[parity][_j])

		print("m",options.back()["steps"])
		var stop = true
		var n = 0
		
#		while stop && n < 0:
#
#			var moves = options.back()["steps"]
#			Global.rng.randomize()
#			var index_r = Global.rng.randi_range(0, moves.size() - 1)
#			parity = int(river.back().vector.grid.x) % 2
#			var grid_ = river.back().vector.grid + Global.array.neighbor[parity][moves[index_r]]
#
#			if check_border(grid_):
#				river.append(Global.array.hex[grid_.y][grid_.x])
#			else:
#				stop = true
#			n+=1
		

		print(river.size())
		
		for hex in river :
			hex.set_terrain(1)
#			if Global.array.hex[grids[_i].y][grids[_i].x].number.terrain != 2:
#				Global.array.hex[grids[_i].y][grids[_i].x].set_terrain(0)

func init_polars():
	#polar.set_terrain(4)
	var polar = Global.array.hex[0][Global.data.size.n]

func cnt():
#	var count = 0
#	for _y in Global.data.size.map.y:
#		for _x in Global.data.size.map.x:
#			if Global.array.hex[_y][_x].flag.visiable:
#				count += 7
#			if Global.array.square150[_y][_x].flag.visiable:
#				count += 5
#			if Global.array.square90[_y][_x].flag.visiable:
#				count += 5
#			if Global.array.square30[_y][_x].flag.visiable:
#				count += 5
#			if Global.array.triangle180[_y][_x].flag.visiable:
#				count += 4
#			if Global.array.triangle0[_y][_x].flag.visiable:
#				count += 4
#	print(count)
	pass

func paint_maps():
	for _y in Global.data.size.map.y:
		for _x in Global.data.size.map.x:
			if Global.array.hex[_y][_x].flag.visiable:
				var _i = (Global.array.hex[_y][_x].number.hue) % 8
				if Global.array.hex[_y][_x].number.terrain != -1:
					_i = Global.array.hex[_y][_x].number.terrain
				Global.node.TileMapHex.set_cell(_x,_y,_i) 
			if Global.array.square30[_y][_x].flag.visiable:
				var _i = (Global.array.square30[_y][_x].number.hue) % 8
				Global.node.TileMapSquare30.set_cell(_x,_y,_i) 
			if Global.array.square90[_y][_x].flag.visiable:
				var _i = (Global.array.square90[_y][_x].number.hue) % 8
				Global.node.TileMapSquare90.set_cell(_x,_y,_i) 
			if Global.array.square150[_y][_x].flag.visiable:
				var _i = (Global.array.square150[_y][_x].number.hue) % 8
				Global.node.TileMapSquare150.set_cell(_x,_y,_i) 
			if Global.array.triangle180[_y][_x].flag.visiable:
				var _i = (Global.array.triangle180[_y][_x].number.hue) % 8
				Global.node.TileMapTriangle180.set_cell(_x,_y,_i) 
			if Global.array.triangle0[_y][_x].flag.visiable:
				var _i = (Global.array.triangle0[_y][_x].number.hue) % 8
				Global.node.TileMapTriangle0.set_cell(_x,_y,_i) 

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

func check_border(grid_):
	var flag = ( grid_.x >= Global.data.size.map.x ) || ( grid_.x < 0 ) || ( grid_.y >= Global.data.size.map.y ) || ( grid_.y < 0 )
	return !flag

func _on_Timer_timeout():
	Global.node.TimeBar.value +=1
	
	if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
		Global.node.TimeBar.value -= Global.node.TimeBar.max_value
