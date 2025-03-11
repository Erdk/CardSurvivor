extends HBoxContainer


func _on_player_health_changed(current_value, max_value):
	var halfs = int(current_value / max_value * 8)
	
	%Heart4.set_state(halfs - 6)
	%Heart3.set_state(halfs - 4)
	%Heart2.set_state(halfs - 2)
	%Heart1.set_state(halfs)
