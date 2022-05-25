extends Node


func _ready():
	#calc_roll()
	
	init_beasts()
	pass

func calc_roll():
	var n = 6
	var k = 5
	var array = []
	
	for _i in pow(n,k):
		var number = _i 
		var arr_ = []
		
		while arr_.size() < 5:
			var _j = number % n
			arr_.append(_j)
			number = int(ceil(number / n))
		arr_.invert()
		array.append(arr_)
	print(array.pop_back())
	print(array.size())

func init_dices():
	var input = {}
	input.index = Global.list.primary_key.dice
	input.edges = 6
	input.values = ["I","I","I","II","II","III"]
	var dice = Classes.Dice.new(input)
	Global.array.dice.append(dice)
	Global.list.primary_key.dice += 1

func init_beasts():
	init_dices()
	
	var input = {}
	input.index = Global.list.primary_key.beast
	var beast = Classes.Beast.new(input)
	Global.array.beast.append(beast)
	Global.list.primary_key.beast += 1
	
	input.index = Global.list.primary_key.beast
	beast = Classes.Beast.new(input)
	Global.array.beast.append(beast)
	Global.list.primary_key.beast += 1

func _on_Timer_timeout():
	Global.node.TimeBar.value +=1
	
	if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
		Global.node.TimeBar.value -= Global.node.TimeBar.max_value
