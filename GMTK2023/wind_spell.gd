extends StaticBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collision_shape_2d.shape.radius < 46:
		collision_shape_2d.shape.radius += 250 * delta
	else:
		queue_free()
	animated_sprite_2d.play("default")
		
