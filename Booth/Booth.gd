extends Node2D

const Duck = preload("res://Booth//Duckling.tscn")

export (int) var spawn_time = 2

func _ready():
	$Timer.wait_time = spawn_time

func _on_Timer_timeout():
	spawn_new_duck()

func spawn_new_duck():
	var GrabedInstance = Duck.instance()
	var PathFollowInstance = PathFollow2D.new()
	
	PathFollowInstance.add_child(GrabedInstance)
	$Path2D2.add_child(PathFollowInstance)
	
	#PathFollowInstance.add_child(GrabedInstance)
	# Add different change for ducks here
	#var GrabedInstance= Duck.instance()
	#$Path2D2/PathFollow2D.add_child(GrabedInstance)
	$Timer.wait_time = spawn_time