extends EnemyBase

@onready var squeak_sound = $SqueakSound

func _ready():
	super._ready()
	if randi_range(1, 3) == 1: squeak_sound.play()
	


func unique_wander(move_vector):
	position.x = move_vector.x
	position.y = move_vector.y

func unique_run(move_vector):
	position.x = move_vector.x
	position.y = move_vector.y
		

