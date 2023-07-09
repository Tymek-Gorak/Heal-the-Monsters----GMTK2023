extends AnimatedSprite2D

var campfire_animation_tier = ["T-1", "T0", "T1", "T2", "T3", "T4", ]
var campfire_tier = 0
var bonus_time_earning = 5
var time_running = 0
var is_ticking = false
var enemy_spawn_min_time = 4.0
var enemy_spawn_max_time = 7.0
var points = 0


@onready var game_time_left = $GameTimeLeft
@onready var campfire_glint = $CampfireGlint
@onready var spawn_enemy_timer = $SpawnEnemyTimer
@onready var campfire_zone = $CampfireZone
@onready var heal_sound = $HealSound
@onready var campfire_sound = $CampfireSound
@onready var level_up_sound = $LevelUpSound
@onready var level_down_sound = $LevelDownSound
@onready var extuinguish_sound = $ExtuinguishSound
@onready var lobby_music_sound = $LobbyMusicSound
@onready var battle_music_sound = $BattleMusicSound
@onready var quiet_sound = $QuietSound
@onready var cpu_particles_2d = $CPUParticles2D

@onready var texture_progress_bar = $"../TextureProgressBar"
@onready var game_over_screen = $"../GameOverScreen"

func _ready():
	
	Global.time_left_sec = 20

func _process(delta):
	play(campfire_animation_tier[campfire_tier])
	campfire_glint.play(campfire_animation_tier[campfire_tier])
	
	if spawn_enemy_timer.is_stopped() and is_ticking:
		get_parent().spawn_enemy()
		spawn_enemy_timer.wait_time = randf_range(enemy_spawn_min_time, enemy_spawn_max_time)
		
		if enemy_spawn_min_time > 1: enemy_spawn_min_time -= .2
		elif enemy_spawn_min_time > .5: enemy_spawn_min_time -= .025
		
		if enemy_spawn_max_time > 2: enemy_spawn_max_time -= .3
		elif enemy_spawn_max_time > 1.2: enemy_spawn_max_time -= .025
		
		if bonus_time_earning > 1.5: bonus_time_earning -= .1
		
		if game_time_left.wait_time > 0.5: game_time_left.wait_time -= 0.025
		spawn_enemy_timer.start()
	
	
	
	
	var sec_remaining = Global.time_left_sec
	#campfire tiers advance at: 12, 24, 36, 48
	if sec_remaining >= 48:
		if campfire_tier != 5:
			if campfire_tier < 5:
				level_up_sound.play()
			else:
				level_down_sound.play()
		campfire_tier = 5
		
	elif sec_remaining >= 36:
		if campfire_tier != 4:
			if campfire_tier < 4:
				level_up_sound.play()
			else:
				level_down_sound.play()
		campfire_tier = 4
		
	elif sec_remaining >= 24:
		if campfire_tier != 3:
			if campfire_tier < 3:
				level_up_sound.play()
			else:
				level_down_sound.play()
		campfire_tier = 3
		
	elif sec_remaining >= 12:
		if campfire_tier != 2:
			if campfire_tier < 2:
				level_up_sound.play()
			else:
				level_down_sound.play()
		campfire_tier = 2
		
	elif sec_remaining >= 1:
		if campfire_tier != 1:
			if campfire_tier < 1:
				level_up_sound.play()
			else:
				level_down_sound.play()
		campfire_tier = 1
		
	else:
		campfire_tier = 0
	
	if campfire_tier == 5:
		offset.y = -4.5
	else:
		offset = Vector2(0, 0)
		
	if sec_remaining <= -1:
		extuinguish_sound.play()
		campfire_sound.stop()
		battle_music_sound.stop()
		quiet_sound.play()
		cpu_particles_2d.emitting = false	
		is_ticking = false
		texture_progress_bar.visible = !texture_progress_bar.visible
		game_over_screen.visible = !game_over_screen.visible
		Global.time_left_sec = 0
		Global.is_game_lost = true
		campfire_zone.monitoring = false
		get_tree().call_group("enemies", "game_over")


func _on_campfire_zone_body_entered(body):
	if body.is_healed == false:
		points += 1
		if points == 2:
			is_ticking = true
			get_parent().start_game()
			lobby_music_sound.stop()
			battle_music_sound.play()
		heal_sound.play()
		Global.time_left_sec += bonus_time_earning
		body.healed()


func _on_game_time_left_timeout():
	if is_ticking:
		Global.time_left_sec -= 1
		time_running += 1
