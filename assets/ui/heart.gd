extends Control

const full_heart = preload("res://assets/ui/hearts/full.png")
const half_heart = preload("res://assets/ui/hearts/half.png")
const empty_heart = preload("res://assets/ui/hearts/empty.png")

func set_state(new_state):
	if new_state <= 0:
		%Tex.set_texture(empty_heart)
	elif new_state == 1:
		%Tex.set_texture(half_heart)
	else:
		%Tex.set_texture(full_heart)
