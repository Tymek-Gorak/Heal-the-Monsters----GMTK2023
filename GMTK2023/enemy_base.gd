extends CharacterBody2D
class_name EnemyBase

@export var SPEED = 30.0
@export var move_range = 20

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animated_sprite_2d_healed = $AnimatedSprite2DHealed
@onready var wander_timer = $WanderTimer
@onready var healing_particles = $HealingParticles

var wander_spot : Vector2
var player_in_range = false
var starting_position
var is_healed = false
var player_saved = null
var not_moving = false


func _ready():
	starting_position = position

func _physics_process(delta):
	if not_moving == false:
		var move_vector
		if player_in_range == true and is_healed == false:
			move_vector = run_away(delta)
			unique_run(move_vector)
		else:
			move_vector = pick_wander_spot(delta)
			unique_wander(move_vector)
			
		if move_and_slide():
			unique_collision()

func pick_wander_spot(delta):
	if wander_timer.is_stopped():
		wander_timer.wait_time = randf_range(0.5, 1.5)
		wander_timer.start()
		wander_spot = Vector2(randf_range(-move_range, move_range), randf_range(-move_range, move_range))
	var direction = position.direction_to(wander_spot + starting_position)
	
	var move_toward_x = move_toward(position.x, (wander_spot + starting_position).x, SPEED * delta)
	var move_toward_y = move_toward(position.y, (wander_spot + starting_position).y, SPEED * delta)
	
	if position.x < move_toward_x:
		animated_sprite_2d.scale.x = -1
	elif position.x > move_toward_x:
		animated_sprite_2d.scale.x = 1
		
	if move_toward(position.x, wander_spot.x, SPEED * delta) == position.x and move_toward(position.y, wander_spot.y, SPEED * delta) == position.y:
		animated_sprite_2d.play("idle")
	else:	

		animated_sprite_2d.play("walk")
	return Vector2(move_toward_x, move_toward_y)
	
func run_away(delta):
	#var move_toward_x = move_toward(position.x, player_saved.position.x, -SPEED * 2.5 * delta)
	#var move_toward_y = move_toward(position.y, player_saved.position.y, -SPEED * 2.5 * delta)
	var direction = position.direction_to(player_saved.position) * -SPEED * 3 * delta 
	
	var move_toward_x = direction.x + position.x
	var move_toward_y = direction.y + position.y
	
	if move_toward_x > position.x :
		animated_sprite_2d.scale.x = -1
	else:
		animated_sprite_2d.scale.x = 1
		
	animated_sprite_2d.play("walk")
	
	return Vector2(move_toward_x, move_toward_y)
		
func unique_wander(move_vector):
	pass


func unique_run(move_vector):
	pass

func unique_collision():
	pass

func healed():
	get_parent().enemies_on_screen -= 1
	animated_sprite_2d.hide()
	animated_sprite_2d_healed.show()
	animated_sprite_2d = animated_sprite_2d_healed
	starting_position = Vector2(0, 0)
	modulate = Color8(256,256,256, int(256 * 0.3))
	move_range = 30
	healing_particles.emitting = true
	healing_particles.modulate = Color8(256,256,256, int(256))
	set_collision_mask_value(5, true)
	is_healed = true
	await get_tree().create_timer(30).timeout
	queue_free()
	
func game_over():
	starting_position = Vector2(randf_range(-125, 125), randf_range(-55, 55))
	while abs(starting_position.x) < 39 and abs(starting_position.y) < 39:
			starting_position = Vector2(randf_range(-125, 125), randf_range(-55, 55))
	modulate = Color8(256,256,256, 256)

func player_detected(player):
	player_in_range = true
	wander_timer.stop()
	player_saved = player
	
func player_left():
	player_in_range = false
	starting_position = position
	wander_spot = Vector2(randf_range(-move_range, move_range), randf_range(-move_range, move_range))
	
