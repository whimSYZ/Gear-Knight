extends Node

# Member variables
var taken = false

func _on_body_enter( body ):
	if (not taken and body extends preload("res://player.gd") ):
		get_node("anim").play("taken")
		taken = true
		get_node("../../game_state").coins += 1
		get_node("../../hud/coin_number").set_text("C in:"+str(get_node("../../game_state").coins))
		var f = File.new()
		f.open("user://coins", File.WRITE)
		f.store_var(get_node("../../game_state").coins)
	elif (not taken and body extends preload("res://player_sword.gd")):
		get_node("anim").play("taken")
		taken = true
		get_node("../../game_state").coins += 1
		get_node("../../hud/coin_number").set_text("C in:"+str(get_node("../../game_state").coins))
		var f = File.new()
		f.open("user://coins", File.WRITE)
		f.store_var(get_node("../../game_state").coins)