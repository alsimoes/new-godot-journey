extends Actor

# velocity.y = min(speed.y, velocity.y)

func _physics_process(delta) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and velocity.y < 0.0
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed, is_jump_interrupted)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
		)

func calculate_move_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	speed: Vector2,
	is_jump_interrupted: bool) -> Vector2:
	var output: Vector2 = linear_velocity
	output.x = speed.x * direction.x
	output.y += gravity * get_physics_process_delta_time()
	
	if direction.y == -1.0:
		output.y = speed.y * direction.y
		
	if is_jump_interrupted:
		output.y = 0.0
	
	return output
