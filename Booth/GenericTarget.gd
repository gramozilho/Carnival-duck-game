extends KinematicBody2D

signal score_update
signal got_hit


export (int) var speed = 500
export (float) var despawn_time = 3
export (int) var score = 5

onready var parent = get_parent()

var alive = true
var velocity = Vector2()
var target_in_place = false
var type = 'target'

func _ready():
	$Area2D/CollisionArea.shape = $CollisionShape2D.shape
	$Area2D/CollisionArea.shape.radius = $CollisionShape2D.shape.radius
	$AnimationPlayer.play("starting_state")
	$Timer.wait_time = despawn_time

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
	emit_signal("score_update", score)


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and alive:
		if event.is_pressed():
			emit_signal("got_hit", self) #, [get_instance_id()])
			#print('signal that got hit sent: ', get_instance_id())
			#shot_down()


func _on_Timer_timeout():
	self.queue_free()


func no_more_shooting():
	alive = false
