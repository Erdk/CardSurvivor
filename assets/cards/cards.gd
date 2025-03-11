extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")

var hp = 3
var in_knock_back = false
var knock_back_time = 0.0
const max_knock_back_time = 0.1

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	if in_knock_back:
		direction *= -1
		knock_back_time += delta
		if knock_back_time > max_knock_back_time:
			in_knock_back = false
		
	velocity = direction * 300.0
	move_and_slide()

func take_damage():
	hp -= 1
	if hp == 0:
		queue_free()
		const SMOKE_SCENE = preload("res://assets/sfx/explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		get_parent().increase_kill_count()
		smoke.global_position = global_position

func knock_back():
	in_knock_back = true
	knock_back_time = 0.0
