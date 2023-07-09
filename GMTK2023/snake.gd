extends EnemyBase

@onready var hiss_sound = $HissSound

func _ready():
	super._ready()
	if randi_range(1, 3) == 1: hiss_sound.play()
	healing_particles = $HealingParticles
	

func unique_wander(move_vector):
	if abs(position.direction_to(Vector2(move_vector.x, 0)).x) > abs(position.direction_to(Vector2(0, move_vector.y)).y):
		position.x = move_vector.x
	else:
		position.y = move_vector.y

func unique_run(move_vector):
	if abs(position.direction_to(player_saved.position).x) > abs(position.direction_to(player_saved.position).y):
		position.x = move_vector.x
	else:
		position.y = move_vector.y
		
