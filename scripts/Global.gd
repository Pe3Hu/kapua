extends Node


var rng = RandomNumberGenerator.new()
var list = {}
var array = {}
var scene = {}
var node = {}
var ui = {}
var obj = {}
var flag = {}
var data = {}

func init_window_size():
	list.window_size = {}
	list.window_size.width = ProjectSettings.get_setting("display/window/size/width")
	list.window_size.height = ProjectSettings.get_setting("display/window/size/height")
	list.window_size.center = Vector2(list.window_size.width/2, list.window_size.height/2)

func init_primary_key():
	list.primary_key = {}
	list.primary_key.lord = 0
	list.primary_key.dummy = 0
	list.primary_key.encounter = 0

func init_list():
	init_window_size()
	init_primary_key()

func init_array():
	array.hex = []
	array.square150 = []
	array.square90 = [] 
	array.square30 = [] 
	array.triangle0 = []
	array.triangle180 = [] 
	array.neighbor = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]

func init_scene():
	pass

func init_node():
	node.TimeBar = get_node("/root/Game/TimeBar") 
	node.Game = get_node("/root/Game") 
	node.TileMapHex = get_node("/root/Game/TileMaps/TileMapHex") 
	node.TileMapSquare150 = get_node("/root/Game/TileMaps/TileMapSquare150") 
	node.TileMapSquare90 = get_node("/root/Game/TileMaps/TileMapSquare90") 
	node.TileMapSquare30 = get_node("/root/Game/TileMaps/TileMapSquare30") 
	node.TileMapTriangle0 = get_node("/root/Game/TileMaps/TileMapTriangle0") 
	node.TileMapTriangle180 = get_node("/root/Game/TileMaps/TileMapTriangle180") 
	
func init_obj():
	obj.field = {}
	ui.bar = []

func init_data():
	data.size = {}
	data.size.n = 5
	data.size.map = Vector2(data.size.n * 2 + 1, data.size.n * 2 + 1)
	data.size.bar = Vector2(91, 30)
	data.size.cell = Vector2(140, 164)
	data.hex = {}
	data.hex.a = 60
	data.scale = 0.25

func init_flag():
	flag.ready = false
	flag.generate = true

func _ready():
	init_list()
	init_array()
	init_scene()
	init_node()
	init_obj()
	init_data()
	init_flag()

func add_child_node(parent_node_path_,child_node_):
	#set position if needed
	#child_node_.global_transform = global_transform
	
	#var p = get_node(parent_node_path_)
	#var parent_node = get_node(parent_node_path_).add_child(child_node_)
	pass
	
