class_name Player
extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var camera: Camera2D = $MainCamera

@export var inv : Inv
@export var Dictionaryinv : Inv
@onready var sprite: AnimatedSprite2D = $Sprite2D
var diraddon = "F"
@onready var item_dictionary: Control = $"Item Dictionary"

@export var top : Node2D
@export var left : Node2D
@export var bot : Node2D
@export var right : Node2D

func _ready() -> void:
	item_dictionary.collect.connect(collect_for_dict)

func _physics_process(delta: float) -> void:

	camera.limit_left = left.global_position.x
	camera.limit_right = right.global_position.x
	camera.limit_top = top.global_position.y
	camera.limit_bottom = bot.global_position.y

	if Input.is_action_just_pressed("Zoom In"):
		camera.zoom += Vector2(.1, .1)
	if Input.is_action_just_pressed("Zoom Out"):
		camera.zoom -= Vector2(.1, .1)
	if camera.zoom > Vector2(4.0, 4.0):
		camera.zoom = Vector2(4.0, 4.0)
	if camera.zoom < Vector2(1.75, 1.75):
		camera.zoom = Vector2(1.75, 1.75)

	$Money.text = str(PlayerGlobals.money) + "$"

	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	if direction:
		if Input.is_action_just_pressed("Left"):
			diraddon = "L"
		if Input.is_action_just_pressed("Right"):
			diraddon = "R"
		if Input.is_action_just_pressed("Up"):
			diraddon = "B"
		if Input.is_action_just_pressed("Down"):
			diraddon = "F"
		sprite.play("Walk" + diraddon)
		velocity = direction * SPEED
		$WalkSFX.play()
	else:
		velocity = Vector2.ZERO
		sprite.play("Idle" + diraddon)
		$WalkSFX.stop()

	move_and_slide()



func collect(item, number):
	inv.insert(item, number)

func collect_for_dict():
	Dictionaryinv.insert(item_dictionary.item, 100)

func clear(item):
	inv.clear(item)

func player_shop_method():
	pass
