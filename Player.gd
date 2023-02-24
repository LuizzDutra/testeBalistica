extends Node2D

var m_press = false

var proj = load("res://Projectile.tscn")

func _ready():
	$Camera2D.intensity = 10

func _physics_process(delta):
	$Arm.rotation = (get_global_mouse_position()- $Arm.global_position).angle()
	#if m_press:
	#	shoot()

func _unhandled_input(event):
	if event.is_action("shoot"):
		if event.is_pressed():
			#m_press = true
			shoot()
		else:
			m_press = false
		
		
func shoot():
	$Camera2D.start_shake()
	var projectile = proj.instance()
	projectile.global_position = $Arm.get_node("Tip").global_position
	projectile.dir = (get_global_mouse_position() - $Arm.get_node("Tip").global_position).normalized()
	projectile.velocity = projectile.dir * projectile.speed
	get_parent().add_child(projectile)
