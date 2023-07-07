extends CharacterBody2D

var wander_spot : Vector2

@export var SPEED = 60.0
@export var JUMP_VELOCITY = -400.0
@export var move_range = 20

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animated_sprite_2d_healed = $AnimatedSprite2DHealed
@onready var wander_timer = $WanderTimer

var player_in_range = false
var starting_position
var is_healed = false
var player_saved = null


func _ready():
	starting_position = position

func _physics_process(delta):
	if player_in_range == true and is_healed == false:
		run_away(delta)
	else:
		handle_wandering(delta)
	
	move_and_slide()

func handle_wandering(delta):
	if wander_timer.is_stopped():
		wander_timer.wait_time = randf_range(0.5, 1.5)
		wander_timer.start()
		wander_spot = Vector2(randf_range(-move_range, move_range), randf_range(-move_range, move_range))
	var direction = position.direction_to(wander_spot + starting_position)
	
	var move_toward_x = move_toward(position.x, (wander_spot + starting_position).x, SPEED * delta)
	var move_toward_y = move_toward(position.y, (wander_spot + starting_position).y, SPEED * delta)
	if abs(move_toward_x) > abs(move_toward_y):
		position.x = move_toward_x
	else:	
		position.y = move_toward_y
	
	if position.x < move_toward_x:
		animated_sprite_2d.scale.x = -1
	elif position.x > move_toward_x:
		animated_sprite_2d.scale.x = 1
		
	
	if move_toward(position.x, wander_spot.x, SPEED * delta) == position.x and move_toward(position.y, wander_spot.y, SPEED * delta) == position.y:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("walk")
	
func run_away(delta):
	var move_toward_x = move_toward(position.x, player_saved.position.x, -SPEED * 1.5 * delta)
	var move_toward_y = move_toward(position.y, player_saved.position.y, -SPEED * 1.5 * delta)
	if abs(position.direction_to(player_saved.position).x) > abs(position.direction_to(player_saved.position).y):
		position.x = move_toward_x
	else:	
		position.y = move_toward_y
	if position.x < move_toward_x:
		animated_sprite_2d.scale.x = -1
	elif position.x > move_toward_x:
		animated_sprite_2d.scale.x = 1
		

func healed():
	animated_sprite_2d.hide()
	animated_sprite_2d_healed.show()
	animated_sprite_2d = animated_sprite_2d_healed
	starting_position = Vector2(0,0)
	move_range = 30
	is_healed = true

func player_detected(player):
	player_in_range = true
	player_saved = player
	
func player_left():
	player_in_range = false
	starting_position = position
	wander_spot = Vector2(randf_range(-move_range, move_range), randf_range(-move_range, move_range))
	
