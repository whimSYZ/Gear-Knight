extends Node

# Member variables

func _on_body_enter( body ):
	if (body extends preload("res://player.gd")):
		get_parent().get_node("Turtorial").show()
	pass # replace with function body