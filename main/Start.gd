extends Control

func _on_Start_pressed():
	get_node("anim").play("startbuttom")

func _on_anim_finished():
	get_tree().change_scene("res://stage_1.tscn")
	var f = File.new()
	f.open("user://coins", File.WRITE)
	f.store_var(0)
	f.open("user://current_stage", File.WRITE)
	f.store_var(1)