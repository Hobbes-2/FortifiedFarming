extends Camera2D

var sway_amount: float = 10.0
var sway_speed: float = 1.0
@onready var walk_sfx: AudioStreamPlayer = $"../../../AudioStreamPlayer"
@onready var sway_timer: Timer = $SwayTimer

var footstep_time = 2.0

var t := 0.0

func _process(delta):
	t += delta * sway_speed
#left-right then up-down
	offset = Vector2(sin(t) * sway_amount, cos(t * 2.0) * sway_amount * 0.5)
	#print(offset)
	if abs(offset.x) >= 9.9 and (offset.y) <= -4.9:
		walk_sfx.play()

func _on_sway_timer_timeout() -> void:
	offset.y += -6 * exp(-footstep_time * 8)
	sway_timer.start()
