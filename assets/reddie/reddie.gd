extends CharacterBody2D

const SHOT_RATE = 0.1
var elapsed_time = 0

var process_input = true

signal health_changed(old_value, new_value)
const MAX_HP = 16.0
var hp = 16.0

signal hes_dead_jimmy()

var attack_sounds = [
	preload("res://assets/sounds/sonniss/swoosh1.wav"),
	preload("res://assets/sounds/sonniss/swoosh2.wav"),
	preload("res://assets/sounds/sonniss/swoosh3.wav"),
	preload("res://assets/sounds/sonniss/swoosh4.wav"),
	preload("res://assets/sounds/sonniss/swoosh5.wav")
]

func disable_input():
	%Arrow.hide()
	process_input = false

func _process(delta):
	if !process_input:
		%Sprajty.play("idle")
		return
	
	# move Firefox
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	
	# rotate arrow according to mouse position
	var mouse_position = get_global_mouse_position()
	%Center.look_at(mouse_position)
	
	# shot at 0.1s rate tops!
	elapsed_time += delta
	if Input.is_action_pressed("fire") && elapsed_time > SHOT_RATE:
		elapsed_time = 0
		shoot()
	
	# flip only when moving along x
	if direction.x < 0:
		%Sprajty.flip_h = true
	elif direction.x > 0:
		%Sprajty.flip_h = false
	
	if velocity.length() > 0.0:
		%Sprajty.play("run")
	else:
		%Sprajty.play("idle")
		
	var enemis_close = %HurtBox.get_overlapping_bodies()
	if enemis_close.size() > 0:
		if !%AudioStreamPlayer.playing:
			%AudioStreamPlayer.stream = attack_sounds[0]
			%AudioStreamPlayer.play()
		%Sprajty.play("hurt")
		for enemy in enemis_close:
			if enemy.has_method("knock_back"):
				enemy.knock_back()
		hp -= 1.0 * enemis_close.size() * delta
		health_changed.emit(hp, MAX_HP)
		if hp <= 0.0:
			# death
			print("death")
			hes_dead_jimmy.emit()

func shoot():
	const FIREBALL = preload("res://assets/reddie/fireball.tscn")
	var fireball = FIREBALL.instantiate()
	fireball.global_position = %FireHole.global_position
	fireball.global_rotation = %FireHole.global_rotation
	%FireHole.add_child(fireball)
	
	#const DMG_RATE = 5.0
