extends CharacterBody2D


@export var SPEED = 50.0
@export var MAX_SPEED_X = 200.0
@export var MAX_SPEED_Y = 100.0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var noise_area = $NoiseArea

func _physics_process(delta):


	handle_movement(delta)
	move_and_slide()
	
func handle_movement(delta):
	var directionx = Input.get_axis("left", "right")
	var directiony = Input.get_axis("down", "up")
	
	if directionx or directiony:
		animated_sprite_2d.play("walk")
		animated_sprite_2d.speed_scale = 1
	else:
		animated_sprite_2d.play("idle")
		animated_sprite_2d.speed_scale = 0.8
		

	if directionx < 0:
		velocity.x = move_toward(velocity.x, -MAX_SPEED_X, SPEED * delta)
		animated_sprite_2d.scale.x = 1
	elif directionx > 0:
		velocity.x = move_toward(velocity.x, MAX_SPEED_X, SPEED * delta)
		animated_sprite_2d.scale.x = -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	if directiony > 0:
		velocity.y = move_toward(velocity.y, -MAX_SPEED_Y, SPEED * delta)
	elif directiony < 0:
		velocity.y = move_toward(velocity.y, MAX_SPEED_Y, SPEED * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)



func _on_noise_area_body_entered(body):
	body.player_detected(self)


func _on_noise_area_body_exited(body):
	body.player_left()
