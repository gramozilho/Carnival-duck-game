extends Control

signal start_game
signal animation_started
signal gameover

func _on_Target_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			emit_signal("start_game")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "StartGameImages":
		emit_signal("animation_started")
	else:
		emit_signal("gameover")
