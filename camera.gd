extends Camera2D

onready var timer = $Timer

var shaking = false
var intensity = 10
var time = 0.1
var dir = Vector2.ZERO
var shake_offset = Vector2.ZERO
var prev_offset = offset

func _process(_delta):
	if shaking:
		shake()


func shake():
	dir = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	shake_offset += dir * intensity
	shake_offset = shake_offset.limit_length(intensity)
	offset = prev_offset + shake_offset
	if timer.time_left == 0:
		shaking = false
		shake_offset = Vector2.ZERO
		offset = prev_offset

func start_shake():
	if shaking:
		timer.wait_time = time
		timer.start()
	else:
		shaking = true
		prev_offset = offset
		timer.wait_time = time
		timer.start()
