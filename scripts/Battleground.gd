extends Node2D



func _ready():
	init_combination()
	init_beast()
	
	init_encounter()
	
func init_combination():
	var input_combination = {}
	input_combination.requests = []
	input_combination.outcomes = []
	
	var request = Global.array.request[2]
	input_combination.requests.append(request)
	
	var input_outcome = {}
	var target = {}
	target.primary = "enemy"
	target.second = "hp"
	input_outcome.target = target
	var result = {}
	result.damage = {}
	result.damage.kind = "common"
	result.damage.value = 4
	input_outcome.result = result
	var outcome = Classes.Outcome.new(input_outcome)
	input_combination.outcomes.append(outcome)
	add_combination(input_combination)

func init_beast():
	var input = {}
	input.dice = Global.array.dice[0]
	input.combinations = []
	var combination = Global.array.combination[0]
	input.combinations.append(combination)
	add_beast(input)
	
	input = {}
	input.dice = Global.array.dice[0]
	input.combinations = []
	combination = Global.array.combination[0]
	input.combinations.append(combination)
	add_beast(input)

func init_encounter():
	var input = {}
	input.beast = []
	var beast = Global.array.beast[0]
	input.beast.append(beast)
	beast = Global.array.beast[1]
	input.beast.append(beast)
	var encounter = Classes.Encounter.new(input)
	
	encounter.start()

func add_beast(input_):
	input_.index = Global.list.primary_key.beast 
	var beast = Classes.Beast.new(input_)
	Global.array.beast.append(beast)
	Global.list.primary_key.beast += 1

func add_combination(input_):
	input_.index = Global.list.primary_key.combination 
	var combination = Classes.Combination.new(input_)
	Global.array.combination.append(combination)
	Global.list.primary_key.combination += 1
