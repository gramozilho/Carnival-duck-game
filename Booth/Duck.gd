extends "res://Booth/Target.gd"

onready var parent = get_parent()

func control(delta):
	parent.set_offset(parent.get_offset() + speed * delta)
