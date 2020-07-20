extends Node

var coins = 0
var health = 3
var current_stage = 1

func _ready():
	var f = File.new()
	if (f.open("user://coins", File.READ) == OK):
		coins = f.get_var()
		get_node("../hud/coin_number").set_text("C in:"+str(coins))
	if (f.open("user://current_stage", File.READ) == OK):
		current_stage = f.get_var()

func next_stage():
	var f = File.new()
	f.open("user://current_stage", File.WRITE)
	f.store_var(current_stage)