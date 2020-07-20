extends Node

# Member variables
var player = ResourceLoader.load("res://player.tscn")

func _on_body_enter( body ):
	if (body extends preload("res://player.gd")):
		get_node("../player").die()
	elif (body extends preload("res://player_sword.gd")):
		get_node("../player_sword").die()