extends Node2D

@export var rest_length = 260.0
@export var stiffness = 12.0
@export var damping = 0.1

@onready var player = $".."
@onready var ray: RayCast2D = $RayCast2D
@onready var rope: Line2D = $Line2D

var launched: bool = false
var target: Vector2

func _process(delta):
	# Only the owner reads input and runs the physics
	if is_multiplayer_authority():
		ray.look_at(get_global_mouse_position())

		if Input.is_action_just_pressed("grapple"):
			launch()
		if Input.is_action_just_released("grapple"):
			retract()

		if launched:
			handle_grapple(delta)

	# Everyone (owner and remote peers) draws the rope from the synced state
	update_rope()

func launch():
	if ray.is_colliding():
		target = ray.get_collision_point()
		launched = true
		sync_grapple.rpc(true, target)

func retract():
	launched = false
	sync_grapple.rpc(false, target)

# Runs on the other peers when the owner latches or releases
@rpc("authority", "call_remote", "reliable")
func sync_grapple(is_launched: bool, hook_point: Vector2) -> void:
	launched = is_launched
	target = hook_point

func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)

	var displacement = target_dist - rest_length

	var force = Vector2.ZERO

	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude

		var vel_dot = player.linear_velocity.dot(target_dir)
		var damping_force = -damping * vel_dot * target_dir

		force = spring_force + damping_force

	player.linear_velocity += force * delta

func update_rope():
	rope.visible = launched
	if launched:
		rope.set_point_position(1, to_local(target))
