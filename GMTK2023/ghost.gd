extends EnemyBase

@onready var tp_timer = $TPTimer
@onready var teleport_animation_player = $Teleport
@onready var collision_shape_2d = $CollisionShape2D
@onready var moan_sound = $MoanSound

var teleport_range = Vector2(125, 55)
var campfire_teleport_range = Vector2(25, 25)

func _process(delta):
	if tp_timer.is_stopped() == false:
		animated_sprite_2d.play("idle")


func pick_wander_spot(delta):
		pass
	
func run_away(delta):
		pass

func teleport():
	var teleport_location = Vector2(randf_range(-teleport_range.x, teleport_range.x), randf_range(-teleport_range.y, teleport_range.y))
	if is_healed == false:
		while abs(teleport_location.x) < 45 and abs(teleport_location.y) < 42:
			teleport_location = Vector2(randf_range(-teleport_range.x, teleport_range.x), randf_range(-teleport_range.y, teleport_range.y))
	if randi_range(1, 24) == 1: moan_sound.play()
	position = teleport_location
	
func restart_teleport():
	tp_timer.wait_time = randf_range(1.2, 3)
	tp_timer.start()

func healed():
	teleport_range = campfire_teleport_range
	super.healed()

func _on_tp_timer_timeout():
	teleport_animation_player.play("teleport")
