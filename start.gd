extends Control

func _on_quit_button_pressed():
	get_tree().quit()


func _on_setting_button_pressed():
	pass # Replace with function body.


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://survivors_game.tscn")


func _on_reddie_ready():
	%Reddie.disable_input()
