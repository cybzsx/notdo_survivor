class_name MainUI extends Node2D






	
	
	#region button part

func _on_game_button_pressed() -> void:
	
	Scenemanager.transition_to_scene("grass_land")


func _on_exit_button_pressed() -> void:
	
	get_tree().quit()



	#endregion 
