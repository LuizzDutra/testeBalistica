extends KinematicBody2D

onready var hitbox = $Area2D

var damage = 10
var speed = 2400
var pen_type = 2
var collided_bodies = []

var dir = Vector2.ZERO
var velocity = Vector2.ZERO
var grav = Vector2(0, 9.8)

func _ready():
	$Trace.emitting = true
	$Timer.start()
	var start_modulate = $ColorRect.modulate

func _physics_process(delta):
	if get_slide_count() > 0:
		queue_free()
	
	velocity += grav * 42 * delta
	velocity = move_and_slide(velocity)


func _on_Timer_timeout():
	queue_free()


func _on_Area2D_area_entered(area):
	if not area in collided_bodies:
		collided_bodies.append(area)
		$Trace.emitting = false
		match pen_type:
			0:
				queue_free()
			1:
				damage *= 0.5
				speed *= 0.5
				apply_spread(90, .25)
				pen_type = 0
			2:
				damage *= 0.75
				speed *= 0.75
				apply_spread(30, .30)
				pen_type = 1
			_:
				queue_free()
		impact_change_glow(0.75)
		#print(damage)
		

func impact_change_glow(intensity: float):
	var new_glow = 1 + ($ColorRect.modulate[0] - 1) * intensity
	$ColorRect.modulate = Color(new_glow, new_glow, new_glow)

func change_dir(vector: Vector2):
	dir = vector
	velocity = vector * speed

func apply_spread(angle: float, speed_deviation: float = 0):
	if speed_deviation != 0:
		speed *= rand_range(1 - speed_deviation, 1)
	angle /= 2
	change_dir(Vector2.RIGHT.rotated(velocity.normalized().angle() 
			  + deg2rad(rand_range(-angle, angle))))
	
	

func _on_Area2D_area_exited(area):
	if area in collided_bodies:
		collided_bodies.erase(area)
