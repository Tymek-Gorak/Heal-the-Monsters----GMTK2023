extends Node2D

static var time_left_sec = 20
static var highscore = 0
var is_game_lost = false
var is_on_mobile = false
		


func _process(delta):
	if is_game_lost == false:
		time_left_sec = clamp(time_left_sec, -1, 60)
		
	
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
