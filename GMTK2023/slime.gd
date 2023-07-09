extends EnemyBase

@onready var dash_animation = $DashAnimation
@onready var collision_sound = $CollisionSound
@onready var cpu_particles_2d = $CPUParticles2D

func unique_wander(move_vector):
	position.x = move_vector.x
	position.y = move_vector.y

func unique_run(move_vector):
	var move_vector2 = pick_wander_spot(get_physics_process_delta_time())
	unique_wander(move_vector2)

func dash():
	var direction_to_player = self.position.direction_to(player_saved.position)
	velocity = direction_to_player * SPEED * 20
	await get_tree().create_timer(.2).timeout
	not_moving = false
	
	
func unique_collision():
	not_moving = false
	if randi_range(1, 120) == 10: collision_sound.play()
	cpu_particles_2d.emitting = false
	velocity = Vector2.ZERO

func campfire_angy_sound():
	get_parent().slime_angy_sound_invoke()

func campfire_charge_sound():
	get_parent().slime_charge_sound_invoke()

func _on_anger_detector_body_entered(body):
	if not_moving == false:
		not_moving = true
		dash_animation.play("angy")
	

