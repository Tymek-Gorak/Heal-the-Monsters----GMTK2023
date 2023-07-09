extends Sprite2D

@onready var score_label = $CenterContainer/ScoreLabel
@onready var high_score_label = $CenterContainer2/HighScoreLabel

@export var campfire : AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	high_score_label.text = str(Global.highscore)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if campfire != null:
		score_label.text = str(campfire.points)
		if  campfire.points > int(high_score_label.text):
			Global.highscore = campfire.points
			high_score_label.text = str(Global.highscore)
