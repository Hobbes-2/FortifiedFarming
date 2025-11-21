extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var camera : Camera2D = $Camera2D

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("Zoom In"):
		camera.zoom += Vector2(.1, .1)
	if Input.is_action_just_pressed("Zoom Out"):
		camera.zoom -= Vector2(.1, .1)
	if camera.zoom > Vector2(3.0, 3.0):
		camera.zoom = Vector2(3.0, 3.0)
	if camera.zoom < Vector2(0.5, 0.5):
		camera.zoom = Vector2(0.5, 0.5)

	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
