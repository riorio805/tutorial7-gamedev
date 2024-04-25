extends RayCast


func _ready():
	pass

func _process(delta: float) -> void:
	var collider = get_collider()
	
	if Input.is_action_just_pressed("interact"):
		if is_colliding() and collider.has_method("interact"):
			collider.interact()
		else:
			PlayerItems.drop_item()
