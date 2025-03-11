extends CharacterBody2D

var hp = 100.0
signal hp_depleted

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	const DMG_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		hp -= DMG_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = hp
		if hp <= 0.0:
			hp_depleted.emit()
