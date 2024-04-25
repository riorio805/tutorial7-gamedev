extends RigidBody

var grab_force = 1
var item_cog = null
var is_picked = false
onready var collision = $"CollisionShape"

func interact():
	if PlayerItems.add_item(self):
		is_picked = true

func drop():
	is_picked = false

func select():
	collision.disabled = false

func unselect():
	collision.disabled = true

func _ready():
	var player = get_parent().find_node("Player", false, true)
	item_cog = player.item_cog
	grab_force = player.grab_force

func _physics_process(delta: float) -> void:
	if is_picked:
		gravity_scale = 0
		linear_damp = 8
		var force = (item_cog.global_translation - self.global_translation) * 69
		self.add_central_force(force)
	else:
		gravity_scale = 2
		linear_damp = -1
