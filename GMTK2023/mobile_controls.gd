extends CanvasLayer

signal use_move_vector
signal spell_mobile
signal run_mobile

var move_vector = Vector2(0,0)
var joystick_active = false
@onready var inner_joystick = $MobileButtons/Joystick/Sprite2D

@onready var mobile_buttons = $MobileButtons
@onready var joystick = $MobileButtons/Joystick
@onready var click_sound = $EnableMobileControlsButton/AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	
	
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if joystick.is_pressed():
			move_vector = calculate_move_vector(event.position)
			joystick_active = true
			inner_joystick.global_position = event.position
			inner_joystick.position = inner_joystick.position.clamp(Vector2(3,3), Vector2(29,29)) 
			inner_joystick.visible = true
			print(event.position)
	if event is InputEventScreenTouch:
		if event.pressed == false:
			move_vector = Vector2(0,0 )
			joystick_active = false
			inner_joystick.visible = true
	

func _physics_process(delta):
	emit_signal("use_move_vector", delta,  move_vector)

func calculate_move_vector(event_position):
	var texture_center = joystick.position + Vector2(32, 32)
	return (event_position - texture_center)

func _on_enable_mobile_controls_button_pressed():
	Global.is_on_mobile = !Global.is_on_mobile
	mobile_buttons.visible = !mobile_buttons.visible
	click_sound.play()


func _on_run_button_pressed():
	run_mobile.emit(true)

func _on_run_button_released():
	run_mobile.emit(false)

func _on_spell_button_pressed():
	spell_mobile.emit()


