extends AnimatedSprite2D

var campfire_animation_tier = ["T0", "T1", "T2", "T3"]
var campfire_tier = 0

func _process(delta):
	play(campfire_animation_tier[campfire_tier])
	
func advance_tier():
	campfire_tier+=1
	clamp(campfire_tier, 0, 3)
