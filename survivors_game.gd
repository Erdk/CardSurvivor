extends Node2D


var game_paused = false
var end = false

func _on_player_hes_dead_jimmy():
	pause_all(true, "Next time buster!\n\nSomething something\nquitting before scoring big!")
	end = true


func _on_enemies_mortage_paid():
	pause_all(true, "You won\n\nYou've got your house!")
	end = true
	

func pause_all(game_paused, text):
	get_tree().paused = game_paused
	%GameOver.text = text
	if game_paused:
		%GameOver.show()
	else:
		%GameOver.hide()
	
func _process(delta):
	if !end && Input.is_action_just_pressed("pause"):
		game_paused = !game_paused
		pause_all(game_paused, "Pause")
	
	if Input.is_action_pressed("main_menu"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://start.tscn")
