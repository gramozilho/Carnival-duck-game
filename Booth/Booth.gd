extends Node2D

const Duck = preload("res://Booth//Duckling.tscn")
const Target = preload("res://Booth//GenericTarget.tscn")
const GoldDuck = preload("res://Booth//GoldDuckling.tscn")
const Obstacle = preload("res://Booth//Obstacle.tscn")
const PopUpScore = preload("res://PopUpScore.tscn")

export (float) var spawn_time = .5

var score = 0
var state = 'menu'
var instance_id
var areas_shot = []

func _ready():
	$Timer.set_wait_time(spawn_time)
	load_game()
	update_score(0)

func _on_Timer_timeout():
	if state == 'menu':
		spawn_new_duck()
		$Timer.set_wait_time(randi()%3+1)
	elif state == 'game':
		spawn_new_duck()
		$Timer.set_wait_time((randf() + 1)*spawn_time)
		# Maybe Spawn target
		if randi()%21+1 == 1:
			spawn_target()

func spawn_new_duck():
	var GrabedInstance
	if randi()%60+1 == 1:
		GrabedInstance = GoldDuck.instance()
		GrabedInstance.score = 3
	else:
		GrabedInstance = Duck.instance()
	var PathFollowInstance = PathFollow2D.new()
	
	GrabedInstance.connect("score_update", self, "update_score")
	#GrabedInstance.Timer.connect("timeout", self, "update_score")
	#GrabedInstance.connect("got_hit", self, "targets_on_shot")
	connect_got_hit_to_booth(GrabedInstance)
	
	PathFollowInstance.add_child(GrabedInstance)
	$Path2D2.add_child(PathFollowInstance)
	# $Timer.set_wait_time(spawn_time)

func spawn_target():
	var TargetObj = Target.instance()
	var PathFollowInstance = PathFollow2D.new()
	TargetObj.connect("score_update", self, "update_score")
	#print('despawn: ', TargetObj.despawn_time)
	connect_got_hit_to_booth(TargetObj)
	PathFollowInstance.add_child(TargetObj)
	$Path_Target.add_child(PathFollowInstance)

func connect_got_hit_to_booth(obj):
	obj.connect("got_hit", self, "targets_on_shot")

func update_score(score):
	if state == 'menu':
		if Highscore.highscore == 0:
			$Scoreboard/Control/VBoxContainer/Score.text = ""
			$Scoreboard/Control/VBoxContainer/OnDisplayText.text = ""
		else:
			$Scoreboard/Control/VBoxContainer/Score.text = String(Highscore.highscore)
			$Scoreboard/Control/VBoxContainer/OnDisplayText.text = "Highscore:"
	if state != 'menu':
		if score == 0:
			$Scoreboard/Control/VBoxContainer/Score.text = "0"
		else:
			$Scoreboard/Control/VBoxContainer/Score.text = String(int($Scoreboard/Control/VBoxContainer/Score.text) + score)
		$Scoreboard/Control/VBoxContainer/OnDisplayText.text = "Current score:"

func _on_HUD_start_game():
	$Timer.set_paused(true)
	$HUD.visible = false
	$HUD/AnimationPlayer.play("StartGameImages")
	clean_all_targets()
	$Sounds/Start_round.play(0)

func start_game():
	state = 'game'
	update_score(0)
	$Timer.set_wait_time(.5)
	$Timer.set_paused(false)
	$ClockPosition.position.y += 300
	$ClockPosition/Clock.clock_time = 20
	$ClockPosition/Clock.start()
	
	# Add obstacle
	var obstacle = Obstacle.instance()
	var obstacle2 = Obstacle.instance()
	var PathFollowInstance = PathFollow2D.new()
	var PathFollowInstance2 = PathFollow2D.new()
	
	connect_got_hit_to_booth(obstacle)
	connect_got_hit_to_booth(obstacle2)
	
	obstacle.make_tree()
	obstacle.speed = 150
	obstacle2.make_pine()
	obstacle2.speed = 300
	
	PathFollowInstance.add_child(obstacle)
	PathFollowInstance2.add_child(obstacle2)
	$PathObstacles.add_child(PathFollowInstance)
	$PathObstacle2.add_child(PathFollowInstance2)


func menu_game():
	state = 'menu'
	$HUD.visible = true
	update_score(0)
	$Gun.in_menu()

func _on_Clock_time_up():
	state = 'game_over'
	$HUD/AnimationPlayer.play('GameOver')
	$Sounds/End_of_round.play(0)
	clean_all_targets()

func _on_HUD_animation_started():
	start_game()
	$Gun.in_game()

func _on_HUD_gameover():
	#Highscore.highscore = score
	save_game()
	get_tree().reload_current_scene()

func clean_all_targets():
	for path in [$PathObstacles, $Path2D2, $Path_Target]:
		if path:
			for node in path.get_children():
				#node.Timer.set_paused(true)
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
	if $Gun.number_of_bullets > 0:
		var no_obstacle = true
		for area in areas_shot:
			#print('type: ', area.type)
			if area.type != 'target':
				$Sounds/Miss_shot.play(0)
				no_obstacle = false
		if no_obstacle:
			for area in areas_shot:
				if area.type == 'target':
					area.shot_down()
					$Sounds/Hit_shot.play(0)
					if state == "game":
						var newScore = PopUpScore.instance()
						newScore.change_to_score(area.score)
						newScore.position = get_global_mouse_position()
						newScore.z_index = 5
						add_child(newScore)
		if areas_shot == []:
			$Sounds/Miss_shot.play(0)
		areas_shot = []
		$Gun/AnimationPlayer.play('shoot')
		$Gun.remove_bullet()
	else:
		$Gun.out_of_bullets()

func save_game():
	var save_game = File.new()
	save_game.open("C://src//godot//Carnival-duck-game//highscore.save", File.WRITE)
	save_game.store_line($Scoreboard/Control/VBoxContainer/Score.text)
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("C://src//godot//Carnival-duck-game//highscore.save"):
		print('No previous save')
		return # Error! We don't have a save to load.
	
	save_game.open("C://src//godot//Carnival-duck-game//highscore.save", File.READ)
	var current_line = parse_json(save_game.get_line())
	Highscore.highscore = int(current_line)
	save_game.close()
