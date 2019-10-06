extends KinematicBody2D

export (int) var speed = 200
onready var parent = get_parent()

var type = 'obstacle'

signal got_hit

func _process(delta):
	global_rotation = 0

func _physics_process(delta):
	if parent is PathFollow2D:
		parent.set_offset(parent.get_offset() + speed * delta)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			emit_signal("got_hit", self) #, [get_instance_id()])