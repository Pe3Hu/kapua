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

func init_primary_key():
	list.primary_key = {}
	list.primary_key.tile = 0
	list.primary_key.dice = 0
	list.primary_key.beast = 0
	list.primary_key.description = 0
	list.primary_key.request = 0
	list.primary_key.combination = 0

func init_fragment():
	list.fragment = {}
	list.fragment.abbreviation = ["A","B","C","D","E","F","G","H","I","J","L","M","O","P","Q","R","S","T","V","W","Y"]
	list.fragment.part = {
		"Onslaught": {
			"Prelude": ["Jab","Incision","Crush","Wave","Explosion"],#Укол Разрез Раcкол Волна Взрыв 
			"Сulmination": ["Distinct","Volley","Queue","Aim","Flow"],#Одиночный Самонаведение Луч Залп Очередь
			"Epilogue": ["Rune","Seal","Hex","Observance","Massif"]#Руна Печать Заклинание Ритуал Массив
		},
		"Retention": {
			"Prelude": ["Glide","Parry","Block","Let","Teleport","Yoke"],#Скольжение Парирование Блок Барьер Блинк Захват
			"Epilogue": ["Rune","Seal","Hex","Observance","Massif"]#Руна Печать Заклинание Ритуал Массив
		}
	}
	list.fragment.synergy = {}
	
	for abbreviation in list.fragment.abbreviation: 
		list.fragment.synergy[abbreviation] = {}

	var paths = {
		"fragment": "res://data/fragment.json"
	}
	
	for key in paths.keys():
		var data_file: File = File.new()
		data[key] = {}
		
		if data_file.file_exists(paths[key]):
			data_file.open(paths[key], File.READ)
			var data_json = JSON.parse(data_file.get_as_text())
			data_file.close()
			data[key] = data_json.result
			
	for data_ in data["fragment"]:
		var a = list.fragment.part[data_["first_keys"][0]][data_["second_keys"][0]]
		var b = list.fragment.part[data_["first_keys"][1]][data_["second_keys"][1]]
		#sum check
		#var j_sums = [0,0,0,0,0,0]
		#var i_sums = [0,0,0,0,0,0]
		
		for _i in a.size():
			for _j in b.size():
				list.fragment.synergy[a[_i][0]][b[_j][0]] = data_["values"][_i][_j]
				list.fragment.synergy[b[_j][0]][a[_i][0]] = data_["values"][_i][_j]
				#i_sums[_i] += data_["values"][_i][_j]
				#j_sums[_j] += data_["values"][_i][_j]
		#print(j_sums, i_sums)
	
	list.parameter = {}
	list.parameter.abbreviation = ["S","D","I","W"]
	list.parameter.full = ["Strength","Dexterity","Intellect","Will"]#Сила, Ловкость, Интеллект, Воля
	list.aspect = {}
	list.aspect.full = ["Immolation","Vow","Blood","Combination","Unity","Order","Ghost","Soul","Trap","Artillery","Pride"]#Жертва	Клятва	Кровь	Комбо	Единство	Стихия	Приказ	Дух	Душа	Ловушка	Артиллерия	Гордыня
	list.aspect.parameter = {
		"Immolation": {
			"Leader": "S",
			"Wingman": "D"
		},
		"Vow": {
			"Leader": "S",
			"Wingman": "W"
		},
		"Blood": {
			"Leader": "S",
			"Wingman": "I"
		},
		"Combination": {
			"Leader": "D",
			"Wingman": "I"
		},
		"Unity": {
			"Leader": "D",
			"Wingman": "W"
		},
		"Element": {
			"Leader": "I",
			"Wingman": "W"
		},
		"Order": {
			"Leader": "W",
			"Wingman": "I"
		},
		"Ghost": {
			"Leader": "W",
			"Wingman": "D"
		},
		"Soul": {
			"Leader": "W",
			"Wingman": "S"
		},
		"Trap": {
			"Leader": "I",
			"Wingman": "D"
		},
		"Artillery": {
			"Leader": "I",
			"Wingman": "S"
		},
		"Pride": {
			"Leader": "D",
			"Wingman": "S"
		}
		}

func init_request():
	array.symbol = ["I","II","III","IV"]
	array.request = []
	list.request = {}
	var type = "symbol"
	list.request[type] = {}
	
	for subtype in array.symbol:
		list.request[type][subtype] = {}
		
		for _s in range(1,6):
			var input = {}
			input.size = _s
			input.type = type
			input.subtype = subtype
			add_request(input)
	
	type = "serial"
	list.request[type] = {}
	var subtype = "seriatim"
	
	list.request[type] = {}
	list.request[type][subtype] = {}
	
	for _s in range(4,6):
		var input = {}
		input.size = _s
		input.type = type
		input.subtype = subtype
		add_request(input)
	
	print(array.request[20].list)

func init_dice():
	init_request()
	
	array.dice = []
	var input = {}
	input.edges = 6
	input.values = ["I","I","I","II","II","III"]
	add_dice(input) 
	
	input.values = ["I","I","I","II","IV","III"]
	add_dice(input) 
	
	input.values = ["I","I","II","II","IV","III"]
	add_dice(input) 
	
	list.dice = {}
	list.dice.description = []
	var description = {}
	description.index = list.primary_key.description
	var dice = {}
	description.dice = dice

func init_list():
	init_primary_key()
	init_fragment()
	
	list.terrain = {}
	list.terrain.prairie = []
	list.terrain.river = [[]]
	list.terrain.mountain = []
	list.terrain.savanna = []
	list.terrain.taiga = []
	list.terrain.selva = []
	list.terrain.volcano = []
	list.terrain.canyon = []
	list.region = {
		"Mountain": 0,
		"River": 0,
		"Prairie": 0,
		"Savanna": 0,
		"Taiga": 0,
		"Selva": 0,
		"": 0
	}

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
	array.region = []
	array.dice = []
	array.beast = []
	array.combination = []
	
	init_dice()

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
	node.TileMapHue = get_node("/root/Game/TileMaps/TileMapHue") 
	
func init_obj():
	obj.field = {}
	ui.bar = []
	obj.osn = OpenSimplexNoise.new()

func init_data():
	data.size = {}
	data.size.window = {}
	data.size.window.width = ProjectSettings.get_setting("display/window/size/width")
	data.size.window.height = ProjectSettings.get_setting("display/window/size/height")
	data.size.window.center = Vector2(data.size.window.width / 2, data.size.window.height / 2)
	data.size.n = 5
	data.size.rings = data.size.n * 2
	data.size.map = Vector2(data.size.n * 2 + 1, data.size.n * 2 + 1)
	data.size.bar = Vector2(91, 30)
	data.size.cell = Vector2(140, 164)
	data.hex = {}
	data.hex.a = 60
	data.scale = 0.25
	data.osn = {}
	data.osn.min = 1
	data.osn.max = -1
	data.osn.l = 0
	data.dice = {}
	data.dice.count = 5

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

func add_dice(input_):
	input_.index = list.primary_key.dice
	var dice = Classes.Dice.new(input_)
	array.dice.append(dice)
	list.primary_key.dice += 1

func add_request(input_):
	input_.index = list.primary_key.request
	var request = Classes.Request.new(input_)
	array.request.append(request)
	list.request[input_.type][input_.subtype][input_.size] = list.primary_key.request
	list.primary_key.request += 1

func add_child_node(parent_node_path_,child_node_):
	#set position if needed
	#child_node_.global_transform = global_transform
	
	#var p = get_node(parent_node_path_)
	#var parent_node = get_node(parent_node_path_).add_child(child_node_)
	pass
	
