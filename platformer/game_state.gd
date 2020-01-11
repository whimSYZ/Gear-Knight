
extends Node

var coins = 0
var health = 3
# member variables here, example:
# var a=2
# var b="textvar"
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func hurt():
	if (health == 2):
		get_node("../../hud/Gear_anim").play("Hurt_1")
	elif (health == 1):
		get_node("../../hud/Gear_anim").play("Hurt_2")
	elif (health == 0):
		get_node("../../hud/Gear_anim").play("Hurt_3")
	