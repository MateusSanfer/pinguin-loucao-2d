class_name PlayerWallState
extends PlayerState

func enter() -> void:
	super.enter()
	player.anim.play("wall")
	player.velocity = Vector2.ZERO

func physics_update(delta: float) -> void:
	player.velocity.y += player.wall_acceleration * delta
	
	if player.left_wall_detected.is_colliding():
		player.anim.flip_h = false
		player.direction = 1
	elif player.right_wall_detected.is_colliding():
		player.anim.flip_h = true
		player.direction = -1
	else:
		state_machine.change_state(state_machine.get_node("Fall"))
		return
		
	if player.is_on_floor():
		state_machine.change_state(state_machine.get_node("Idle"))
		return
		
	if Input.is_action_just_pressed("jump"):
		player.velocity.x = player.wall_jump_velocity * player.direction
		state_machine.change_state(state_machine.get_node("Jump"))
		return
