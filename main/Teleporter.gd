extends Node

var taken = false

func _on_body_enter( body ):
	if (not taken and body extends preload("res://player.gd")):
		get_node("lantern_anim").play("taken")
		get_node("../game_state").current_stage += 1
		get_node("../game_state").next_stage()
		taken = true
	elif (not taken and body extends preload("res://player_sword.gd")):
		get_node("lantern_anim").play("taken")
		get_node("../game_state").current_stage += 1
		get_node("../game_state").next_stage()
		taken = true

func _on_lantern_anim_finished():
	if taken:
		get_tree().change_scene("res://stage_"+str(get_node("../game_state").current_stage)+".tscn")