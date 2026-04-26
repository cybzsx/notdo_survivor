extends Node


var scenes : Dictionary = { "grass_land": "res://Map/grass_land/grass_land_1.tscn",
 							"main_ui": "res://UI/MainUI/main_ui.tscn",
						}







func transition_to_scene(scene : String):
	var scene_path : String = scenes.get(scene)
	
	if scene_path != null:

		get_tree().paused = true
	
		#await SceneTransition.fade_out()  # map transi
	
		#clear_global_item()      # 转场时需要重置的标记
	
		#level_load_started.emit()
	
		await get_tree().process_frame
	
		get_tree().change_scene_to_file(scene_path)	
	
		#SceneTransition.fade_in_long()  # map transi

		get_tree().paused = false
	
		await get_tree().process_frame

		#level_loaded.emit()





	#
	
func load_new_scene( _path : String ):
	if _path != null:
			#await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file(_path)
