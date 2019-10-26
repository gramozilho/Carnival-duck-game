extends Control

export (int) var clock_time = 10

var clock_running

signal time_up

func _ready():
	clock_running = false

func start():
	$LapTime.wait_time = clock_time
	$LapTime.start()
	$Tick.start()
	clock_running = true
	$SoundTimer.set_wait_time(clock_time - 8)
	$SoundTimer.start()

func _on_LapTime_timeout():
	clock_running = false
	emit_signal("time_up")

func _on_Tick_timeout():
	if clock_running:
		$Pointer.rotation_degrees += 360*$Tick.wait_time/clock_time


func _on_SoundTimer_timeout():
	$TickSound.play(0)
