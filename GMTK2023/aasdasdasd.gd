extends Node2D

@onready var flip_visibility_on_start_nodes = [$TextureProgressBar, $Menuscreen, $MobileControls.get_child(0)]
@onready var enemy_pool = [preload("res://bat.tscn"), preload("res://ghost.tscn"), preload("res://slime.tscn"), preload("res://snake.tscn")]
@onready var slime_angy_sound = $SlimeAngySound
@onready var slime_charge_sound = $SlimeChargeSound
@onready var restart = $GameOverScreen/Restart

var enemies_on_screen = 2

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemies_on_screen == 0:
		spawn_enemy()
	
	restart.visible = Global.is_on_mobile 	
		

func start_game():
	for node in flip_visibility_on_start_nodes:
		
		node.visible = !node.visible

func spawn_enemy():
	var new_enemy = enemy_pool.pick_random().instantiate()

	var spawn_location = Vector2(randf_range(-125, 125), randf_range(-55, 55))
	while abs(spawn_location.x) < 42 and abs(spawn_location.y) < 42:
		spawn_location = Vector2(randf_range(-125, 125), randf_range(-55, 55))
	new_enemy.position = spawn_location
	add_child(new_enemy) 
	enemies_on_screen += 1

func slime_angy_sound_invoke():
	slime_angy_sound.play()

func slime_charge_sound_invoke():
	slime_charge_sound.play()
	
