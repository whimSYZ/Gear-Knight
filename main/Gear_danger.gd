extends Node

func _on_body_enter( body ):
	if (body extends preload("res://player.gd")):
		get_node("../../player").hurt()
	elif (body extends preload("res://player_sword.gd")):
		get_node("../../player_sword").hurt()