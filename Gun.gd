extends KinematicBody2D

var number_of_bullets = 2
var max_bullets = 6
var bullet_time = 1
var game_state = "menu"

func _ready():
	in_menu()

func in_menu():
	$Bullets.visible = false
	game_state = "menu"

func in_game():
	game_state = "game"
	$Bullets.visible = true
	var initial_bullet_list = $Bullets.get_children()
	for i in range(0, number_of_bullets, 1):
		var bullet = initial_bullet_list[i]
		bullet.value  = 100

func _physics_process(delta):
	position.x = get_global_mouse_position().x + 100
	# If on game mode, prepare for new bullet
	if game_state == "game" and number_of_bullets < max_bullets:
		# TODO alter only n# bullets +1		 	
		var bullet_index = 0
		var new_bullet = 0
		for bullet in $Bullets.get_children():
			#print(bullet.name)
			if bullet_index == number_of_bullets:
				#print('up by ', delta*100/bullet_time, bullet)
				bullet.value += delta*100/bullet_time
			
				if bullet.value == 100:
					#print(bullet.name, ' ', 100)
					new_bullet = bullet_index + 1
			
			bullet_index += 1
		if new_bullet:
			add_bullet(new_bullet)

func add_bullet(add=0):
	if add == 0:
		number_of_bullets += 1
	else:
		number_of_bullets = add
	#print('added bullet, total: ', number_of_bullets)

func remove_bullet():
	if game_state == "game":
		number_of_bullets -= 1
		var bullet_index = 0
		var partial_last_bullet = 0
		var first_bullet_to_remove = 0
		var second_bullet_to_remove = 0
		var next_bullet = false
		
		for bullet in $Bullets.get_children():
			if next_bullet:
				partial_last_bullet = bullet.value
				second_bullet_to_remove = bullet_index
				next_bullet = false
			if bullet.value == 100:
				first_bullet_to_remove = bullet_index
				second_bullet_to_remove = bullet_index
				partial_last_bullet = 0
				next_bullet = true
			bullet_index += 1
		
		$Bullets.get_children()[first_bullet_to_remove].value = partial_last_bullet
		$Bullets.get_children()[second_bullet_to_remove].value = 0
			
		#print('removed ', bullet_to_remove, ' total: ', number_of_bullets)

func out_of_bullets():
	$AnimationPlayer.play("no_bullets")
	$NoBullets.play(0)
