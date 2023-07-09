extends TextureProgressBar

@onready var time_left_label = $CenterContainer/TimeLeftLabel



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = Global.time_left_sec + 6
	value = clamp(value, 6, 66)
	time_left_label.text = str(int(Global.time_left_sec))
