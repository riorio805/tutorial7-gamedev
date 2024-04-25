extends Node

var items = [null, null, null, null]
var current_select = 0

func has_item():
	return items[current_select] != null

func add_item(node:Node):
	if items[current_select] == null:
		items[current_select] = node
		print("added " + str(node))
		return true
	else:
		drop_item()
		return false


func drop_item():
	if items[current_select] != null:
		if items[current_select].has_method("drop"):
			items[current_select].drop()
		items[current_select] = null
		return true
	pass


# move selection
func _process(delta):
	var prev_select = current_select
	if Input.is_action_just_pressed("select_left"):
		current_select -= 1
	if Input.is_action_just_pressed("select_right"):
		current_select += 1
	current_select = posmod(current_select, 4)
	if prev_select != current_select:
		if items[prev_select] != null and items[prev_select].has_method("unselect"):
			items[prev_select].unselect()
		if items[current_select] != null and items[current_select].has_method("select"):
			items[current_select].select()
	
	if Input.is_action_just_pressed("debug"):
		print(items)
		print(current_select)
	
	# visibility
	for node in items:
		if not node == null and not node.is_queued_for_deletion():
			node.visible = false
	var node = items[current_select]
	if not node == null and not node.is_queued_for_deletion():
		node.visible = true
