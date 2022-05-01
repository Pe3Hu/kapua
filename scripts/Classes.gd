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
		
		string.edges = -1
		number.ring = -1
		list.neighbor = {
			"3": [],
			"4": [],
			"6": []
		}
