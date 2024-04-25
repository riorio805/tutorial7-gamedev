extends Control


onready var select_circle = $ColorRect/TextureRect

func _process(delta: float) -> void:
	select_circle.rect_position.x = lerp(
		select_circle.rect_position.x, PlayerItems.current_select * 54, 16 * delta)
	for i in range(4):
		var node = PlayerItems.items[i]
		var node_path = NodePath("ColorRect/HBoxContainer/Item %d" % (i+1) + "/Label")
		var label = get_node(node_path)
		if not node == null and not node.is_queued_for_deletion():
			label.text = node.name
		else:
			label.text = ""
