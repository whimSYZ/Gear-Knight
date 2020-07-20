
extends RigidBody2D
# Character Demo, written by Juan Linietsky.
#
# Implementation of a 2D Character controller.
# This implementation uses the physics engine for
# controlling a character, in a very similar way
# than a 3D character controller would be implemented.
#
# Using the physics engine for this has the main
# advantages:
# -Easy to write.
# -Interaction with other physics-based objects is free
# -Only have to deal with the object linear velocity, not position
# -All collision/area framework available
# 
# But also has the following disadvantages:
#  
# -Objects may bounce a little bit sometimes
# -Going up ramps sends the chracter flying up, small hack is needed.
# -A ray collider is needed to avoid sliding down on ramps and  
#   undesiderd bumps, small steps and rare numerical precision errors.
#   (another alternative may be to turn on friction when the character is not moving).
# -Friction cant be used, so floor velocity must be considered
#  for moving platforms.

# Member variables
var anim = ""
var siding_left = false
var jumping = false
var stopping_jump = false
var attacking = false

var WALK_ACCEL = 800.0
var WALK_DEACCEL = 800.0
var WALK_MAX_VELOCITY = 125
var AIR_ACCEL = 600.0
var AIR_DEACCEL = 600.0
var JUMP_VELOCITY = 360
var STOP_JUMP_FORCE = 900.0

var MAX_FLOOR_AIRBORNE_TIME = 0.15

var airborne_time = 1e20
var attack_time = 1e20

var MAX_ATTACK_POSE_TIME = 0.5

var sword = preload("res://sword.tscn")

var floor_h_velocity = 0.0
var enemy
var enemy_class = preload("res://enemy.gd")
var vulnerable = true

func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()
	
	var new_anim = anim
	var new_siding_left = siding_left
	
	# Get the controls
	var move_left = Input.is_action_pressed("move_left") or Input.is_key_pressed(KEY_A)
	var move_right = Input.is_action_pressed("move_right") or Input.is_key_pressed(KEY_D)
	var jump = Input.is_action_pressed("jump") or Input.is_key_pressed(KEY_W)
	var attack = Input.is_action_pressed("shoot") or Input.is_key_pressed(KEY_J) or Input.is_key_pressed(KEY_K)
	var spawn = Input.is_action_pressed("spawn")
	
	if spawn:
		var e = enemy.instance()
		var p = get_pos()
		p.y = p.y - 100
		e.set_pos(p)
		get_parent().add_child(e)
	
	# Deapply prev floor velocity
	lv.x -= floor_h_velocity
	floor_h_velocity = 0.0
	
	# Find the floor (a contact with upwards facing collision normal)
	var found_floor = false
	var floor_index = -1
	
	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)
		if (ci.dot(Vector2(0, -1)) > 0.6):
			found_floor = true
			floor_index = x
	
	# A good idea when impementing characters of all kinds,
	# compensates for physics imprecission, as well as human reaction delay.
	
	if (found_floor):
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air
	
	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump
	if (jumping):
		if (lv.y > 0):
			# Set off the jumping flag if going down
			jumping = false
		elif (not jump):
			stopping_jump = true
		
		if (stopping_jump):
			lv.y += STOP_JUMP_FORCE*step
	
	if (on_floor):
		# Process logic when character is on floor
		if (move_left and not move_right):
			if (lv.x > -WALK_MAX_VELOCITY):
				lv.x -= WALK_ACCEL*step
		elif (move_right and not move_left):
			if (lv.x < WALK_MAX_VELOCITY):
				lv.x += WALK_ACCEL*step
		else:
			var xv = abs(lv.x)
			xv -= AIR_DEACCEL*step
			if (xv < 0):
				xv = 0
			lv.x = sign(lv.x)*xv
		
		# Check jump
		if (not jumping and jump):
			lv.y = -JUMP_VELOCITY
			jumping = true
			stopping_jump = false
			get_node("sound").play("jump")
		
		# Check siding
		if (lv.x < 0 and move_left):
			new_siding_left = true
		elif (lv.x > 0 and move_right):
			new_siding_left = false
		if (jumping):
			new_anim = "jumping"
		elif (abs(lv.x) < 0.01):
			new_anim = "idle"
		else:
			new_anim = "run"
	else:
		#Process logic when the character is in the air
		if (move_left and not move_right):
			if (lv.x > -WALK_MAX_VELOCITY):
				lv.x -= AIR_ACCEL*step
		elif (move_right and not move_left):
			if (lv.x < WALK_MAX_VELOCITY):
				lv.x += AIR_ACCEL*step
		else:
			var xv = abs(lv.x)
			xv -= AIR_DEACCEL*step
			if (xv < 0):
				xv = 0
			lv.x = sign(lv.x)*xv
	
		if (lv.y < 0):
			if (attack_time < MAX_ATTACK_POSE_TIME):
				new_anim = "jumping_weapon"
			else:
				new_anim = "jumping"
		else:
			if (attack_time < MAX_ATTACK_POSE_TIME):
				new_anim = "falling_weapon"
			else:
				new_anim = "falling"
	
	# Update siding
	if (new_siding_left != siding_left):
		if (new_siding_left):
			get_node("sprite").set_scale(Vector2(-1, 1))
		else:
			get_node("sprite").set_scale(Vector2(1, 1))
		
		siding_left = new_siding_left
	
	# Change animation
	if (new_anim != anim):
		anim = new_anim
		get_node("anim").play(anim)
		get_node("sprite").set_modulate("#ffffff")
	
	# Apply floor velocity
	if (found_floor):
		floor_h_velocity = s.get_contact_collider_velocity_at_pos(floor_index).x
		lv.x += floor_h_velocity
	
	# Finally, apply gravity and set back the linear velocity
	lv += s.get_total_gravity()*step
	s.set_linear_velocity(lv)
	

func die():
	get_node("sprite").set_modulate("#ffffff")
	var p = get_pos()
	p.x = 208
	p.y = 1056
	get_node(".").set_pos(p)
	get_node("Timer").start()
	get_node("../game_state").health = 3
	get_node("../hud/Gear").set_self_opacity(1)
	get_node("../hud/Gear1").set_self_opacity(1)
	get_node("../hud/Gear2").set_self_opacity(1)
	get_node("../hud/Gear_anim").play("spin")
	get_node("sprite").set_modulate("#ffffff")
	get_node("anim").play("idle")
	get_node("sound").play("hit")
	

#func hurt():
	#var p = get_pos()
	#p.x = p.x - 35
	#p.y = p.y - 35
	#get_node(".").set_pos(p)	

func hurt():
	if (vulnerable):
		vulnerable = false
		get_node("sound").play("hit")
		get_node("Timer").start()
		get_node("sprite").set_modulate("#ffffff")
		get_node("anim").play("hurt")
		get_node("../game_state").health -= 1
		get_node("../hud/Gear_anim").play("Hurt_"+str (get_node("../game_state").health + 1))
	if (get_node("../game_state").health == 0):
		die()

func _on_Gear_anim_finished():
	get_node("../hud/Gear_anim").play("spin")
	
func _ready():
	enemy = ResourceLoader.load("res://enemy.tscn")
	
func vulnerable():
	vulnerable = true
	if !Globals.has_singleton("Facebook"):
		return
	var Facebook = Globals.get_singleton("Facebook")
	var link = Globals.get("facebook/link")
	var icon = Globals.get("facebook/icon")
	var msg = "I just sneezed on your wall! Beat my score and Stop the Running nose!"
	var title = "I just sneezed on your wall!"
	Facebook.post("feed", msg, title, link, icon)

func _on_Sign_body_enter( body ):
	
	pass # replace with function body
