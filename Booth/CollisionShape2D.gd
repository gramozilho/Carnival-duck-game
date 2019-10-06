extends KinematicBody2D

export (int) var speed = 200
onready var parent = get_parent()

func _process(delta):
	global_rotation = 0

func _physics_process(delta):
	if parent is PathFollow2D:
		parent.set_offset(parent.get_offset() + speed * delta)