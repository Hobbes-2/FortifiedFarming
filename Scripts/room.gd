extends Node2D

@onready var scene_transition_anim: AnimationPlayer = $SceneTransitionAnim/AnimationPlayer

var inside : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_transition_anim.get_parent().get_node("ColorRect").visible = true
	scene_transition_anim.get_parent().get_node("ColorRect").color.a = 255
	scene_transition_anim.play("FadeOut")
	await get_tree().create_timer(0.5).timeout
	scene_transition_anim.get_parent().get_node("ColorRect").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Interact"):
		if inside:
			scene_transition_anim.get_parent().get_node("ColorRect").visible = true
			scene_transition_anim.play("FadeIn")
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://Scenes/test_level.tscn")


func _on_room_detect_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		inside = true
