tool
extends Area2D

enum Items {duck_back, duck_brown, duck_outline_back, duck_outline_brown, duck_outline_target_brown, duck_outline_target_white, duck_outline_target_yellow, duck_outline_white, duck_outline_yellow, duck_target_brown, duck_target_white, duck_target_yellow, duck_white, duck_yellow, rifle, rifle_red, shot_blue_large, shot_blue_small, shot_brown_large, shot_brown_small, shot_grey_large, shot_grey_small, shot_yellow_large, shot_yellow_small, stick_metal, stick_metal_broken, stick_metal_outline, stick_metal_outline_broken, stick_wood, stick_woodFixed, stick_woodFixed_outline, stick_wood_broken, stick_wood_outline, stick_wood_outline_broken, target_back, target_back_outline, target_colored, target_colored_outline, target_red1, target_red1_outline, target_red2, target_red2_outline, target_red3, target_red3_outline, target_white, target_white_outline, } 
enum Shapes {circle, rect}

var mouse_on = false
var regions = {
	Items.duck_back: Rect2(534, 444, 99, 95),
	Items.duck_brown: Rect2(636, 638, 99, 95),
	Items.duck_outline_back: Rect2(404, 581, 114, 109),
	Items.duck_outline_brown: Rect2(534, 333, 114, 109),
	Items.duck_outline_target_brown: Rect2(418, 321, 114, 109),
	Items.duck_outline_target_white: Rect2(520, 581, 114, 109),
	Items.duck_outline_target_yellow: Rect2(431, 111, 114, 109),
	Items.duck_outline_white: Rect2(534, 222, 114, 109),
	Items.duck_outline_yellow: Rect2(431, 0, 114, 109),
	Items.duck_target_brown: Rect2(431, 222, 99, 95),
	Items.duck_target_white: Rect2(635, 444, 99, 95),
	Items.duck_target_yellow: Rect2(547, 0, 99, 95),
	Items.duck_white: Rect2(547, 97, 99, 95),
	Items.duck_yellow: Rect2(636, 541, 99, 95),
	Items.rifle: Rect2(144, 0, 142, 319),
	Items.rifle_red: Rect2(288, 0, 141, 319),
	Items.shot_blue_large: Rect2(468, 692, 30, 30),
	Items.shot_blue_small: Rect2(534, 541, 20, 20),
	Items.shot_brown_large: Rect2(500, 692, 30, 30),
	Items.shot_brown_small: Rect2(532, 714, 20, 20),
	Items.shot_grey_large: Rect2(404, 692, 30, 30),
	Items.shot_grey_small: Rect2(532, 692, 20, 20),
	Items.shot_yellow_large: Rect2(436, 692, 30, 30),
	Items.shot_yellow_small: Rect2(547, 194, 20, 20),
	Items.stick_metal: Rect2(686, 125, 30, 123),
	Items.stick_metal_broken: Rect2(716, 0, 14, 59),
	Items.stick_metal_outline: Rect2(648, 0, 34, 127),
	Items.stick_metal_outline_broken: Rect2(686, 375, 18, 63),
	Items.stick_wood: Rect2(684, 0, 30, 123),
	Items.stick_woodFixed: Rect2(686, 250, 30, 123),
	Items.stick_woodFixed_outline: Rect2(650, 129, 34, 127),
	Items.stick_wood_broken: Rect2(716, 61, 14, 59),
	Items.stick_wood_outline: Rect2(650, 258, 34, 127),
	Items.stick_wood_outline_broken: Rect2(706, 375, 18, 63),
	Items.target_back: Rect2(274, 595, 128, 128),
	Items.target_back_outline: Rect2(0, 576, 142, 142),
	Items.target_colored: Rect2(144, 595, 128, 128),
	Items.target_colored_outline: Rect2(0, 432, 142, 142),
	Items.target_red1: Rect2(404, 451, 128, 128),
	Items.target_red1_outline: Rect2(0, 144, 142, 142),
	Items.target_red2: Rect2(274, 465, 128, 128),
	Items.target_red2_outline: Rect2(144, 321, 142, 142),
	Items.target_red3: Rect2(144, 465, 128, 128),
	Items.target_red3_outline: Rect2(0, 288, 142, 142),
	Items.target_white: Rect2(288, 321, 128, 128),
	Items.target_white_outline: Rect2(0, 0, 142, 142),
}
var shapes_dict = {
	Shapes.circle: true,
	Shapes.rect: false
}

export (Items) var type setget _update_type
export (Shapes) var collision_type setget _update_coll
export (int) var speed

func _update(_type, _collision_type):
	if !Engine.editor_hint:
		yield(self, 'tree_entered')
	$Sprite.region_rect = regions[type]
	if collision_type:
		# rectangle shape
		print('rect')
		var rect = RectangleShape2D.new()
		rect.extents = $Sprite.region_rect.size/2
		$CollisionShape2D.shape = rect 
	else:
		# circle shape
		print('circle')
		var cicl = CircleShape2D.new()
		cicl.radius = max($Sprite.region_rect.size[0]/2, $Sprite.region_rect.size[1]/2)
		$CollisionShape2D.shape = cicl 

func _update_type(_type):
	type = _type
	_update(type, collision_type)

func _update_coll(_collision_type):
	collision_type = _collision_type
	_update(type, collision_type)
	
func control():
	pass
