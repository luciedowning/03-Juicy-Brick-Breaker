extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
var time_fall = 0.8 
var time_a = 0.8 
var time_rotate = 1.0 
var time_s = 1.2
var time_v = 1.5



var powerup_prob = 0.1

func _ready():
	randomize()
	position.x = new_position.x
	position.y = -100
	$Tween.interpolate_property(self, "position", position, new_position, 0.5 + randf()*2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()
	if score >= 100:
		$ColorRect.color = Color8(230,119,0)
	elif score >= 90:
		$ColorRect.color = Color8(216,245,162)
	elif score >= 80:
		$ColorRect.color = Color8(153,233,242)
	elif score >= 70:
		$ColorRect.color = Color8(9,146,104)
	elif score >= 60:
		$ColorRect.color = Color8(255,224,102)
	elif score >= 50:
		$ColorRect.color = Color8(232,89,12)
	elif score >= 40:
		$ColorRect.color = Color8(11,114,133)
	else:
		$ColorRect.color = Color8(165,216,255)

func _physics_process(_delta):
	if dying and not $Tween.is_active():
		queue_free()

func hit(_ball):
	var brick_sound = get_node_or_null("/root/Game/Brick_Sound")
	if brick_sound != null:
		brick_sound.play()
	die()

func die():
	dying = true
	collision_layer = 0
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instance()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
	$Tween.interpolate_property(self, "position", Vector2(position.x, 1000), time_fall, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.interpolate_property(self,"rotation", -PI + randf()*2*PI, time_rotate, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ColorRect,"color:a", $ColorRect.color.a, 0, time_a, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ColorRect, "color:s", $ColorRect.color.v, 0, time_s, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ColorRect, "color:v", $ColorRect.color.v, 0, time_v, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
