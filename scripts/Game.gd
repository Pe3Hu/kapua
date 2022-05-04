extends Node


func _ready():
	init_maps()
	around_center()
	init_rings()
	init_terrains()
	grow_regions()
	
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
	Global.node.TileMapSquare90.position.y = offset.y + a * sqrt(3) + 1 * Global.data.scale 
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
	#fixed_terrain()
	init_regions_after_mountain()
	init_rivers()
	init_polars()
	connect_hexs()

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
	
	var gate_size = 1
	organize_convergence(original_elements, reflected_elements, gate_size)
	
	reflected_elements.invert()
	#make gate
	options = []
	for _i in original_elements.size():
		options.append("original")
		
	for _i in reflected_elements.size():
		options.append("reflected")
	
	Global.rng.randomize()
	index_r = Global.rng.randi_range(0, options.size() - 1)
	#make gate end
	
	
	for original_element in original_elements:
		Global.list.terrain.mountain.append(original_element)
	for reflected_element in reflected_elements:
		Global.list.terrain.mountain.append(reflected_element)
#	for _i in range(0,reflected_elements.size()-1,1):
#		Global.list.terrain.mountain.append(reflected_elements[_i])
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

func init_rivers():
	var region_centers = []
	
	for region in Global.array.region:
		var center = Vector2()
		
		for hex in region:
			center += hex.vector.grid
		
		center /= region.size()
		region_centers.append(Vector2(int(round(center.x)),int(round(center.y))))
	
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
		var original_elements = [start]
		var moves = options.back()["steps"]
		
		if moves[0] == moves[1]:
			var move = moves[0]
			moves = []
			
			for _i in range(-1,2,1):
				var index =  (_i + move + int(Global.array.neighbor[0].size() * 1.5)) % Global.array.neighbor[0].size()
				moves.append(index)
		else:
			for _i in moves.size():
				moves[_i] = (moves[_i] + int(Global.array.neighbor[0].size() * 0.5)) % Global.array.neighbor[0].size()
		
		var ends = []
		
		for move in moves:
			var grid = Vector2(region_centers.back().x, region_centers.back().y)
			var n = 0
			
			while Global.array.hex[grid.y][grid.x].number.ring < Global.data.size.rings:
				parity = int(round(grid.x)) % 2
				grid += Global.array.neighbor[parity][move]
				
			
			ends.append(Global.array.hex[grid.y][grid.x])
		
		var direction = ends.front().vector.grid.distance_squared_to(ends.back().vector.grid)
		
		if ends.size() == 3:
			ends.pop_at(1)
		
		var overs = []
		
		while ends.front() != ends.back():
			options = []
			var empty = []
			
			for hex in ends.back().array.hex:
				
				if !ends.has(hex):
					if hex.number.ring == Global.data.size.rings:
						var d = ends.front().vector.grid.distance_squared_to(hex.vector.grid) 
						var option = {
							"hex": hex,
							"d": d
						}
						
						if direction >= d:
							options.append(option)
							
						empty.append(option)
			if empty.size() == 1:
				options = empty
				
			if options.size() > 0 :
				bubble_sort(options, "d")
				
				ends.append(options.front()["hex"])
				direction = options.front()["d"]
				
				if options.front()["hex"].string.terrain == "Mountain":
					overs = []
					overs.append_array(ends)
					#rint("?",ends.size())
			else:
				ends.append(ends.front())
				
		#erase Mountain division
		if overs.size() > 0:
			for over in overs:
				ends.erase(over)
			
		var gate_size = 1
		var reflected_elements = [Global.array.hex[int(round(center.y))][int(round(center.x))]]
		organize_convergence(original_elements, reflected_elements, gate_size)
		reflected_elements.invert()
		
		for original_element in original_elements:
			Global.list.terrain.river.back().append(original_element)
		for reflected_element in reflected_elements:
			Global.list.terrain.river.back().append(reflected_element)
		
		original_elements = [Global.array.hex[int(round(center.y))][int(round(center.x))]]
		Global.rng.randomize()
		var index_r = Global.rng.randi_range(0, ends.size() - 1)
		reflected_elements = [ends[index_r]]
		organize_convergence(original_elements, reflected_elements, gate_size)
		reflected_elements.invert()
		
		for original_element in original_elements:
			Global.list.terrain.river.back().append(original_element)
		for reflected_element in reflected_elements:
			Global.list.terrain.river.back().append(reflected_element)
	
	for river in Global.list.terrain.river:
		for _i in range(river.size() - 2,-1,-1):
			if river[_i] == river[_i + 1]:
				river.remove(_i + 1)
				
	for river in Global.list.terrain.river:
		for hex in river:
			hex.set_terrain(1)

func init_polars():
	init_regions_after_mountain()
	
	var regions = []
	var polar = Global.array.hex[0][Global.data.size.n]
	
	for _i in Global.array.region.size():
		var center = Vector2()
		
		for hex in Global.array.region[_i]:
			center += hex.vector.grid
		
		center /= Global.array.region[_i].size()
		var d = center.distance_squared_to(polar.vector.grid)
		var obj = {
			"index": _i,
			"hexs": Global.array.region[_i],
			"size": -Global.array.region[_i].size(),
			"polar_d": d
		}
		regions.append(obj)
		
	var top_4 = regions.duplicate(true)
	bubble_sort(top_4, "size")
	top_4.resize(4)
	bubble_sort(top_4, "polar_d")
#
	var nearest = {
		"region": 0,
		"hex": -1,
		"d": Global.data.size.map.x + Global.data.size.map.y
	}
	
	for hex in top_4[nearest["region"]]["hexs"]:
		var d_ = hex.vector.grid.distance_to(polar.vector.grid)

		if nearest["d"] > d_:
			nearest["d"] = d_
			nearest["hex"] = hex
			
	Global.list.terrain.taiga.append(nearest["hex"])
	
	Global.rng.randomize()
	var index_r = Global.rng.randi_range(0, top_4[1]["hexs"].size() - 1)
	Global.list.terrain.prairie.append(top_4[1]["hexs"][index_r])
	
	Global.rng.randomize()
	index_r = Global.rng.randi_range(0, top_4[2]["hexs"].size() - 1)
	Global.list.terrain.selva.append(top_4[2]["hexs"][index_r])
	
	nearest = {
		"region": 3,
		"hex": -1,
		"d": Global.data.size.map.x + Global.data.size.map.y
	}
	
	polar = Global.array.hex[Global.data.size.rings][Global.data.size.n]
	
	for hex in top_4[nearest["region"]]["hexs"]:
		var d_ = hex.vector.grid.distance_to(polar.vector.grid)

		if nearest["d"] > d_:
			nearest["d"] = d_
			nearest["hex"] = hex
		
	Global.list.terrain.savanna.append(nearest["hex"])
	
	for hex in Global.list.terrain.taiga:
		hex.set_terrain(4)
	for hex in Global.list.terrain.prairie:
		hex.set_terrain(0)
	for hex in Global.list.terrain.selva:
		hex.set_terrain(5)
	for hex in Global.list.terrain.savanna:
		hex.set_terrain(3)

func connect_hexs():
	
	for _i in Global.list.terrain.mountain.size()-1:
		var squares = Global.list.terrain.mountain[_i].get_joint_neighbors(Global.list.terrain.mountain[_i + 1])
		
		for square in squares:
			square.set_terrain(2)
			
	for river in Global.list.terrain.river:
		for _i in river.size()-1:
			var squares = river[_i].get_joint_neighbors(river[_i + 1])
			
			for square in squares:
				square.set_terrain(1)

func grow_regions():
	var terrains = ["Prairie","Savanna","Taiga","Selva"]
	var n = 200
	
	for _i in n:
		for terrain in terrains:
			grow_terrain(terrain)

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
				
				if Global.array.square30[_y][_x].number.terrain != -1:
					_i = Global.array.square30[_y][_x].number.terrain
				Global.node.TileMapSquare30.set_cell(_x,_y,_i) 
				
			if Global.array.square90[_y][_x].flag.visiable:
				var _i = (Global.array.square90[_y][_x].number.hue) % 8
				
				if Global.array.square90[_y][_x].number.terrain != -1:
					_i = Global.array.square90[_y][_x].number.terrain
				Global.node.TileMapSquare90.set_cell(_x,_y,_i) 
				
			if Global.array.square150[_y][_x].flag.visiable:
				var _i = (Global.array.square150[_y][_x].number.hue) % 8
				
				if Global.array.square150[_y][_x].number.terrain != -1:
					_i = Global.array.square150[_y][_x].number.terrain
				Global.node.TileMapSquare150.set_cell(_x,_y,_i)
				
			if Global.array.triangle180[_y][_x].flag.visiable:
				var _i = (Global.array.triangle180[_y][_x].number.hue) % 8
				
				if Global.array.triangle180[_y][_x].number.terrain != -1:
					_i = Global.array.triangle180[_y][_x].number.terrain
				Global.node.TileMapTriangle180.set_cell(_x,_y,_i) 
			
			if Global.array.triangle0[_y][_x].flag.visiable:
				var _i = (Global.array.triangle0[_y][_x].number.hue) % 8
				
				if Global.array.triangle0[_y][_x].number.terrain != -1:
					_i = Global.array.triangle0[_y][_x].number.terrain
				Global.node.TileMapTriangle0.set_cell(_x,_y,_i) 

func bubble_sort(arr_, key_):
	for _i in arr_.size() - 1:
		var flag = false
		
		for _j in arr_.size() - 1 - _i:
			if arr_[_j][key_] > arr_[_j + 1][key_]:
				var temp = arr_[_j]
				arr_[_j] = arr_[_j + 1]
				arr_[_j + 1] = temp
#				flag = true
#
#		if !flag:
#			break
	
	return arr_

func check_border(grid_):
	var flag = ( grid_.x >= Global.data.size.map.x ) || ( grid_.x < 0 ) || ( grid_.y >= Global.data.size.map.y ) || ( grid_.y < 0 )
	return !flag

func organize_convergence(original_elements_, reflected_elements_, gate_size_):
	var d = reflected_elements_.back().vector.grid.distance_to(original_elements_.back().vector.grid)
	var n = 0
	
	while d > gate_size_ && n < 100:
		n+=1
		#procure original stream
		var options = []
		var parity = int(original_elements_.back().vector.grid.x) % 2
		
		for neighbor in Global.array.neighbor[parity]:
			var grid = original_elements_.back().vector.grid + neighbor
			
			if check_border(grid):
				var hex = Global.array.hex[grid.y][grid.x]
				
				if hex.flag.visiable && hex.number.terrain == -1:
					if !original_elements_.has(hex) && !reflected_elements_.has(hex):
						var d_ = reflected_elements_.back().vector.grid.distance_to(grid)
						
						if d >= d_:
							for _i in (d - d_) * 2 + 1:
								options.append(hex)
		
		if options.size() > 0:
			Global.rng.randomize()
			var index_r = Global.rng.randi_range(0, options.size() - 1)
			original_elements_.append(options[index_r])
		
			d = original_elements_.back().vector.grid.distance_to(reflected_elements_.back().vector.grid)
	
			#procure reflected stream
			if d > gate_size_:
				options = []
				parity = int(reflected_elements_.back().vector.grid.x) % 2
				
				for neighbor in Global.array.neighbor[parity]:
					var grid = reflected_elements_.back().vector.grid + neighbor
					
					if check_border(grid):
						var hex = Global.array.hex[grid.y][grid.x]
						
						if hex.flag.visiable && hex.number.terrain == -1:
							if !original_elements_.has(hex) && !reflected_elements_.has(hex):
								var d_ = original_elements_.back().vector.grid.distance_to(grid)
								
								if d >= d_:
									for _i in (d - d_) * 2 + 1:
										options.append(hex)
				
				if options.size() > 0:
					Global.rng.randomize()
					index_r = Global.rng.randi_range(0, options.size() - 1)
					reflected_elements_.append(options[index_r])
		
		d = reflected_elements_.back().vector.grid.distance_to(original_elements_.back().vector.grid)

func get_borderlands(terrain_):
	var tiles = []
	var borderlands = []
	
	match terrain_:
		"Prairie":
			tiles.append_array(Global.list.terrain.prairie)
		"River":
			for river in Global.list.terrain.river:
				tiles.append_array(river)
		"Mountain":
			tiles.append_array(Global.list.terrain.mountain)
		"Savanna":
			tiles.append_array(Global.list.terrain.savanna)
		"Taiga":
			tiles.append_array(Global.list.terrain.taiga)
		"Selva":
			tiles.append_array(Global.list.terrain.selva)
		"Volcano":
			tiles.append_array(Global.list.terrain.volcano)
		"Canyon":
			tiles.append_array(Global.list.terrain.canyon)
			
	for tile in tiles:
		for neighbor in tile.get_neighbors():
			if !borderlands.has(neighbor) && !tiles.has(neighbor) && neighbor.number.terrain == -1:
				borderlands.append(neighbor)
	
	return borderlands

func grow_terrain(terrain_):
	var options = get_borderlands(terrain_)
	if options.size() > 0:
		
		Global.rng.randomize()
		var index_r = Global.rng.randi_range(0, options.size() - 1)
		var tile = options[index_r]
		
		print(tile.string.edges, tile.vector.grid, terrain_, options.size())
		match terrain_:
			"Prairie":
				Global.list.terrain.prairie.append(tile)
				tile.set_terrain(0)
				#print(Global.list.terrain.prairie)
			"River":
				var flag = true
				
				for river in Global.list.terrain.river:
					if flag:
						for tile_ in river:
							if tile_.get_neighbors().has(tile):
								flag = false
								river.append(tile)
								tile.set_terrain(1)
					else:
						break
			"Mountain":
				Global.list.terrain.mountain.append(tile)
				tile.set_terrain(2)
			"Savanna":
				Global.list.terrain.savanna.append(tile)
				tile.set_terrain(3)
				#print(Global.list.terrain.savanna)
			"Taiga":
				Global.list.terrain.taiga.append(tile)
				tile.set_terrain(4)
				#print(Global.list.terrain.taiga)
			"Selva":
				Global.list.terrain.selva.append(tile)
				tile.set_terrain(5)
				#print(Global.list.terrain.selva)
			"Volcano":
				Global.list.terrain.volcano.append(tile)
				tile.set_terrain(6)
			"Canyon":
				Global.list.terrain.canyon.append(tile)
				tile.set_terrain(7)

func fixed_terrain():
	Global.array.hex[2][1].set_terrain(2)
	Global.array.hex[3][1].set_terrain(2)
	Global.array.hex[3][2].set_terrain(2)
	Global.array.hex[2][3].set_terrain(2)
	Global.array.hex[3][3].set_terrain(2)
	Global.array.hex[4][3].set_terrain(2)
	Global.array.hex[5][3].set_terrain(2)
	Global.array.hex[5][4].set_terrain(2)
	Global.array.hex[5][5].set_terrain(2)
	Global.array.hex[5][6].set_terrain(2)
	Global.array.hex[5][7].set_terrain(2)
	Global.array.hex[6][7].set_terrain(2)
	Global.array.hex[7][8].set_terrain(2)
	Global.array.hex[8][8].set_terrain(2)
	Global.array.hex[8][9].set_terrain(2)

func _on_Timer_timeout():
	Global.node.TimeBar.value +=1
	
	if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
		Global.node.TimeBar.value -= Global.node.TimeBar.max_value
