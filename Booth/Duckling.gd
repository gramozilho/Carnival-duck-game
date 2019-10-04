extends KinematicBody2D

export (int) var speed = 50

onready var parent = get_parent()

var alive = true
var velocity = Vector2()
var target_in_place = false

func _ready():
	$Area2D/CollisionArea.shape = $CollisionShape2D.shape
	$Area2D/CollisionArea.shape.radius = $CollisionShape2D.shape.radius
	$AnimationPlayer.play("starting_state")

func control(delta):
	if parent is PathFollow2D:
		parent.set_offset(parent.get_offset() + speed * delta)
	else:
		pass

func _physics_process(delta):
	control(delta)
	move_and_slide(velocity)

func shot_down():
	alive = false
	print('shoots fired')
	$AnimationPlayer.play("shot_down")


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and alive:
		if event.is_pressed():
			shot_down()
