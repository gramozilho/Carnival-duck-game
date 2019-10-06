extends Node2D

const Duck = preload("res://Booth//Duckling.tscn")
const Obstacle = preload("res://Booth//Obstacle.tscn")

export (float) var spawn_time = .5

var score = 0
var state = 'menu'
var instance_id
var areas_shot = []

func _ready():
	$Timer.wait_time = spawn_time

func _on_Timer_timeout():
	if state == 'menu':
		spawn_new_duck()
		$Timer.wait_time = randi()%3+1
	elif state == 'game':
		spawn_new_duck()
		$Timer.wait_time = spawn_time

func spawn_new_duck():
	var GrabedInstance = Duck.instance()
	var PathFollowInstance = PathFollow2D.new()
	
	GrabedInstance.connect("score_update", self, "update_score")
	#GrabedInstance.connect("got_hit", self, "targets_on_shot")
	connect_got_hit_to_booth(GrabedInstance)
	
	PathFollowInstance.add_child(GrabedInstance)
	$Path2D2.add_child(PathFollowInstance)
	$Timer.wait_time = spawn_time

func connect_got_hit_to_booth(obj):
	obj.connect("got_hit", self, "targets_on_shot")

func update_score(score):
	if state != 'menu':
		$Scoreboard/Control/Score.text = String(int($Scoreboard/Control/Score.text) + score)

func _on_HUD_start_game():
	print('Game starting')
	$HUD.visible = false
	$HUD/AnimationPlayer.play("StartGameImages")
	clean_all_targets()

func start_game():
	state = 'game'
	$Timer.wait_time = spawn_time
	$ClockPosition.position.y += 300
	$ClockPosition/Clock.start()
	
	# Add obstacle
	var obstacle = Obstacle.instance()
	var PathFollowInstance = PathFollow2D.new()
	connect_got_hit_to_booth(obstacle)
	PathFollowInstance.add_child(obstacle)
	$PathObstacles.add_child(PathFollowInstance)


func menu_game():
	state = 'menu'
	$HUD.visible = true

func _on_Clock_time_up():
	state = 'game_over'
	$HUD/AnimationPlayer.play('GameOver')
	clean_all_targets()

func _on_HUD_animation_started():
	start_game()

func _on_HUD_gameover():
	get_tree().reload_current_scene()

func clean_all_targets():
	for path in [$PathObstacles, $Path2D2]:
		for node in path.get_children():
			node.queue_free()

func targets_on_shot(obj_ref):
	#print('signal connect to main: ', obj_ref)
	areas_shot.append(obj_ref)
	#print('main connect')

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("shoot"):
			#print('just pressed, deleting:', areas_shot)
			areas_shot = []
			$ShotTimer.start()

func _on_ShotTimer_timeout():
	#print('areas on timeout: ', areas_shot)
	var no_obstacle = true
	for area in areas_shot:
		#print('type: ', area.type)
		if area.type == 'obstacle':
			no_obstacle = false
	if no_obstacle:
		for area in areas_shot:
			if area.type == 'target':
				area.shot_down()
	areas_shot = []
