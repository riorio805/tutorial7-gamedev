extends Area

export (String) var sceneName = "Level 1"

func _on_AreaTrigger_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		get_tree().change_scene(str("res://Scenes/" + sceneName + ".tscn"))
