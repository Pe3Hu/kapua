extends Node


func _ready():
	#calc_roll()
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

func _on_Timer_timeout():
	Global.node.TimeBar.value +=1
	
	if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
		Global.node.TimeBar.value -= Global.node.TimeBar.max_value
