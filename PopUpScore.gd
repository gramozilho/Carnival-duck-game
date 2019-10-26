extends Node2D

export (int) var score = 1

func _ready():
	$AnimationPlayer.play("vanish")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

func change_to_score(value):
	if value == 1:
		$Sprite.region_rect = Rect2(382, 0, 23, 36)
	elif value == 3:
		$Sprite.region_rect = Rect2(365, 111, 28, 36)
	else:
		$Sprite.region_rect = Rect2(359, 310, 29, 36)
