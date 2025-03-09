extends Area2D

func _on_body_entered(body: Node2D):
	if Global.current_level < 3:
		var next_level_path = "res://scenes/level_" + str(Global.current_level + 1) + ".tscn"
		var next_level_scene = load(next_level_path) as PackedScene
		if next_level_scene:
			get_tree().change_scene_to_packed(next_level_scene)
			Global.current_level += 1
