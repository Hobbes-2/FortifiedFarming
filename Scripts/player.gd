class_name Player
extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var camera : Camera2D = $Camera2D

@export var inv : Inv

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("Zoom In"):
		camera.zoom += Vector2(.1, .1)
	if Input.is_action_just_pressed("Zoom Out"):
		camera.zoom -= Vector2(.1, .1)
	if camera.zoom > Vector2(4.0, 4.0):
		camera.zoom = Vector2(4.0, 4.0)
	if camera.zoom < Vector2(1.5, 1.5):
		camera.zoom = Vector2(1.5, 1.5)

	$Money.text = str(PlayerGlobals.money)

	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func collect(item, number):
	inv.insert(item, number)

func clear(item):
	inv.clear(item)

#This is a test to see if git is working
func player_shop_method():
	pass
