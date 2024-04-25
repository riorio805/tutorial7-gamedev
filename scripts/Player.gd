extends KinematicBody

enum State {
	Normal,
	Sprinting,
	Crouching
}

export var speed = 15
export var sprint_speed = 30
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 20
export var mouse_sensitivity = 0.3
export var grab_force = 50
export var normal_fov = 70
export var sprint_fov = 120
export var crouch_mod = 0.6

onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
var y_velocity = 0
var camera_x_rotation = 0
var fov = 0
var state = State.Normal

onready var item_cog = $Head/Camera/Point

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	fov = camera.fov

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("left_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if state == State.Sprinting:
		fov = lerp(fov, sprint_fov, 4 * delta)
	else:
		fov = lerp(fov, normal_fov, 4 * delta)
	camera.fov = fov
	
	if state == State.Crouching:
		scale.y = lerp(scale.y, crouch_mod, 6 * delta)
	else:
		scale.y = lerp(scale.y, 1, 6 * delta)

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis

	var movement_vector = Vector3()
	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head_basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head_basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head_basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head_basis.x

	movement_vector = movement_vector.normalized()
	
	
	if state != State.Sprinting and movement_vector.length_squared() > 1e-5 and Input.is_action_pressed("sprint"):
		state = State.Sprinting
	elif state == State.Sprinting and movement_vector.length_squared() < 1e-5 and not Input.is_action_pressed("sprint"):
		state = State.Normal
	
	if state != State.Crouching and Input.is_action_pressed("crouch"):
		state = State.Crouching
	
	var real_speed = sprint_speed if state == State.Sprinting else speed
	velocity = velocity.linear_interpolate(movement_vector * real_speed, acceleration * delta)
	y_velocity -= gravity
	
	if Input.is_action_pressed("jump") and is_on_floor():
		y_velocity += jump_power

	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)
	y_velocity = velocity.y
