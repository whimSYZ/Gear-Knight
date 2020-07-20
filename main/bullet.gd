extends StaticBody2D

var disabled = false

func disable():
	if (disabled):
		return
	disabled = true
	queue_free()

func _ready():
	get_node("Timer").start()