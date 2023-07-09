extends CharacterBody2D

@export var SPEED = 1000
@export var MAX_SPEED_X = 150.0
@export var MAX_SPEED_Y = 120.0
@export var wind_spell_scene = preload("res://wind_spell.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var noise_area = $NoiseArea
@onready var noise_area_collision_shape = $NoiseArea/CollisionShape2D
@onready var circle_animated_sprite = $CircleAnimatedSprite
@onready var spell_sound = $SpellSound
@onready var walk_sound = $WalkSound
@onready var cpu_particles_2d = $CPUParticles2D
@onready var wind_s_pell_particles = $WindSPellParticles

var is_casting_spell = false

func _physics_process(delta):
	var directionx = Input.get_axis("left", "right")
	var directiony = Input.get_axis("down", "up")
	if !Global.is_on_mobile: handle_movement(delta, Vector2(directionx, directiony))
	
	if Input.is_action_pressed("sneak") and !Global.is_on_mobile:
		handle_sneaking(true)
	elif !Global.is_on_mobile:
		handle_sneaking(false)
	if Input.is_action_just_pressed("wind_spell"):
		wind_spell()
	move_and_slide()
	
func handle_movement(delta, move_vector):
	if Global.is_on_mobile:
		move_vector.y = -move_vector.y
	
	if is_casting_spell == false:
		if move_vector.x or move_vector.y:
			animated_sprite_2d.play("walk")
			animated_sprite_2d.speed_scale = 1
			if !walk_sound.playing:
				walk_sound.play()
		else:
			if walk_sound.playing:
				walk_sound.stop()
			animated_sprite_2d.play("idle")
			animated_sprite_2d.speed_scale = 0.8
		
	if move_vector.x < 0:
		velocity.x = move_toward(velocity.x, -MAX_SPEED_X, SPEED * delta )
		animated_sprite_2d.scale.x = 1
	elif move_vector.x > 0:
		velocity.x = move_toward(velocity.x, MAX_SPEED_X, SPEED * delta )
		animated_sprite_2d.scale.x = -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	if move_vector.y > 0:
		velocity.y = move_toward(velocity.y, -MAX_SPEED_Y, SPEED * delta )
	elif move_vector.y < 0:
		velocity.y = move_toward(velocity.y, MAX_SPEED_Y, SPEED * delta )
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)

func handle_sneaking(is_sneaking):
	print(is_sneaking)
	if is_sneaking:
		noise_area_collision_shape.shape.radius = 40
		MAX_SPEED_X = 200
		MAX_SPEED_Y = 160
		circle_animated_sprite.play("idle_small")
		cpu_particles_2d.emitting = true
	else:
		noise_area_collision_shape.shape.radius = 55
		MAX_SPEED_X = 150
		MAX_SPEED_Y = 120
		circle_animated_sprite.play("idle")
		cpu_particles_2d.emitting = false
		

func wind_spell():
	var spell = wind_spell_scene.instantiate()
	add_sibling(spell)
	spell.position = position
	is_casting_spell = true
	animated_sprite_2d.play("spell") 
	wind_s_pell_particles.restart()
	wind_s_pell_particles.emitting = true
	spell_sound.play (0.3)
	

func _on_noise_area_body_entered(body):
	body.player_detected(self)


func _on_noise_area_body_exited(body):
	if body.is_healed == false:
		body.player_left()


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "spell":
		is_casting_spell = false


func _on_mobile_controls_run_mobile(is_pressed):
	handle_sneaking(is_pressed)


func _on_mobile_controls_spell_mobile():
	wind_spell()


func _on_mobile_controls_use_move_vector(delta, move_vector):
	if Global.is_on_mobile: handle_movement(delta, move_vector)
