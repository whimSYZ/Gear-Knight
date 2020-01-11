extends Node

# Member variables
var taken = false
export var coins = 0

func _on_body_enter( body ):
	if (not taken and body extends preload("res://player.gd")):
		get_node("anim").play("taken")
		coins += 1
		taken = true
		get_node("../../hud/coin_number").set_text("Coins: " + str(coins))
	
func _on_coin_area_enter(area):
	pass # replace with function body


func _on_coin_area_enter_shape(area_id, area, area_shape, area_shape):
	pass # replace with function body


func _on_player_script_changed():
	pass # replace with function body
	

func _on_player_body_enter( body ):
	pass # replace with function body
