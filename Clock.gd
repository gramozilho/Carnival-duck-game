extends Control

export (int) var clock_time = 10

var clock_running

signal time_up

func _ready():
	$LapTime.wait_time = clock_time
	clock_running = false

func start():
	$LapTime.start()
	$Tick.start()
	clock_running = true

func _on_LapTime_timeout():
	clock_running = false
	emit_signal("time_up")

func _on_Tick_timeout():
	if clock_running:
		$Pointer.rotation_degrees += 360*$Tick.wait_time/clock_time
