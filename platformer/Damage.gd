
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"
func _on_body_enter( body ):
	if (body extends preload("res://player.gd")):
		get_node("../../game_state").coins += 1
	get_node("../../hud/coin_number").set_text("yo")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


