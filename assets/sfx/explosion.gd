extends Node2D

func _ready():
	%AnimatedSprite2D.play("explode")
	%AudioStreamPlayer2D.play()
	await %AudioStreamPlayer2D.finished
	await %AnimatedSprite2D.animation_finished
	queue_free()
