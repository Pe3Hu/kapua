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

	
	var n = 5
	var m = 13
	
	
	for _x in m:
		for _y in n:
			var flag = {}
			flag.TileMapHex = true
			flag.TileMapSquare30 = true
			flag.TileMapSquare90 = true
			flag.TileMapSquare150 = true
			flag.TileMapTriangle180 = true
			flag.TileMapTriangle0 = true
			var _i = (_x*n+_y)%8
			
			if _x == 0:
				flag.TileMapSquare30 = false
				flag.TileMapTriangle0 = false
				
			if _x == m-1:
				flag.TileMapSquare150 = false
				flag.TileMapTriangle180 = false
				
			
			if _y == n-1 && _x %2 == 1:
				flag.TileMapTriangle0 = false
				flag.TileMapTriangle180 = false
				flag.TileMapSquare90 = false
			
			if flag.TileMapHex:
				Global.node.TileMapHex.set_cell(_x,_y,_i) 
			if flag.TileMapSquare30:
				Global.node.TileMapSquare30.set_cell(_x,_y,_i) 
			if flag.TileMapSquare90:
				Global.node.TileMapSquare90.set_cell(_x,_y,_i) 
			if flag.TileMapSquare150:
				Global.node.TileMapSquare150.set_cell(_x,_y,_i) 
			if flag.TileMapTriangle180:
				Global.node.TileMapTriangle180.set_cell(_x,_y,_i) 
			if flag.TileMapTriangle0:
				Global.node.TileMapTriangle0.set_cell(_x,_y,_i) 
			
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
	

func _process(delta):
	pass

func _on_Timer_timeout():
	Global.node.TimeBar.value +=1
	
	if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
		Global.node.TimeBar.value -= Global.node.TimeBar.max_value
