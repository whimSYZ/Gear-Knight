extends Node

var taken = false
var player_sword = preload("res://player_sword.tscn")
var pos = get_pos()
onready var player = get_node("../player")
onready var player_sword_exsist = get_node("../../player_sword")

func _on_body_enter( body ):
	if (not taken and body extends preload("res://player.gd")):
		get_node("../hud/sword/sword_anim").play("obtained")
		get_node("Sprite").set_self_opacity(0)
		get_node("Light2D").set_energy(0)
		get_node("../music").set_volume(0)
		
		var pos = get_node("../player").get_pos()
		var si = player_sword.instance()
		get_parent().add_child(si)
		si.set_pos(pos)
		get_parent().remove_child(player)
		get_node("../hud/Gear_anim").connect("finished",player_sword,"_on_Gear_anim_finished")
		taken = true


func _on_sword_anim_finished():
	get_node("../music").set_volume(1)
	get_node("../hud/Gear_anim").disconnect("finished",player,"_on_Gear_anim_finished")