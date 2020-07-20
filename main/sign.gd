extends Node
func _on_body_enter( body ):
	if (body extends preload("res://player.gd")):
		get_parent().get_node("CanvasLayer/Turtorial").popup()
	pass # replace with function body
# Member variables
