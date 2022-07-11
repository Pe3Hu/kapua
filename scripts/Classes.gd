extends Node


class Tile:
	var number = {}
	var string = {}
	var array = {}
	var list = {}
	var flag = {}
	var node = {}
	var vector = {}
	
	func _init(input_):
		number.index = input_.index
		node.parent = input_.parent
		flag.visiable = input_.visiable
		vector.grid = input_.grid
		string.edges = input_.edges
		
		number.ring = -1
		list.neighbor = {
			"3": [],
			"4": [],
			"6": []
		}
		array.hex = []
		number.hue = 7
		number.terrain = -1
		string.terrain = ""
		number.region = -1
	
	func get_neighbors():
		var neighbors = []
		
		for key in list.neighbor.keys():
			neighbors.append_array(list.neighbor[key])
		
		return neighbors
	
	func set_ring_gate():
		if string.edges == "4" && list.neighbor["6"].size() > 1:
			if list.neighbor["6"][0].number.ring == list.neighbor["6"][1].number.ring:
				number.ring = list.neighbor["6"][0].number.ring
	
	func set_terrain(number_):
		number.terrain = number_
		
		match number_:
			0:
				string.terrain = "Prairie"
			1:
				string.terrain = "River"
			2:
				string.terrain = "Mountain"
			3:
				string.terrain = "Savanna"
			4:
				string.terrain = "Taiga"
			5:
				string.terrain = "Selva"
			6:
				string.terrain = "Volcano"
			7:
				string.terrain = "Canyon"
	
	func get_joint_neighbors(tile_):
		var neighbors = []
		var first = get_neighbors()
		var second = tile_.get_neighbors()
		
		for neighbor in first:
			if second.has(neighbor):
				neighbors.append(neighbor)
		
		return neighbors

class Chain:
	var number = {}
	var string = {}
	var array = {}
	
	func _init(input_):
		number.index = input_.index
		string.type

class Beast:
	var number = {}
	var string = {}
	var array = {}
	var list = {}
	var flag = {}
	var node = {}
	var vector = {}
	
	func _init(input_):
		number.index = input_.index

class Dice:
	var number = {}
	var array = {}
	
	func _init(input_):
		number.index = input_.index
		number.edges = input_.edges
		array.value = input_.values

class Combination:
	var number = {}
	var array = {}
	
	func _init(input_):
		number.index = input_.index
		array.request = input_.requests
		array.outcome = input_.outcomes

class Outcome:
	var list = {}
	
	func _init(input_):
		list.target = input_.target
		list.result = input_.result
	
	
	func follow_target():
		var primary = null
		var second = null
		
		match list.target.primary:
			"ally":
				pass
			"enemy":
				pass
		
		
		match list.target.second:
			"hp":
				pass
			"dice":
				pass
			"status":
				pass

class Request:
	var number = {}
	var list = {}
	
	func _init(input_):
		number.index = input_.index
		number.size = input_.size
		list.type = input_.type
		list.subtype = input_.subtype

class Encounter:
	var number = {}
	var array = {}
	
	func _init(input_):
		#number.index = input_.index
		array.beast = input_.beasts
	
	func start():
		print(1)

class Fragment:
	var number = {}
	var string = {}
	var array = {}
	var list = {}
	var flag = {}
	var node = {}
	var vector = {}
	
	func _init(input_):
		number.index = input_.index

class Battleground:
	var number = {}
	var string = {}
	var array = {}
	var list = {}
	var flag = {}
	var node = {}
	var vector = {}
	
	func _init(input_):
		number.index = input_.index
