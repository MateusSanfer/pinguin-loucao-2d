class_name PlayerFallState
extends PlayerState

func enter() -> void:
	super.enter()
	player.anim.play("fall")

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move(delta)
	
	if Input.is_action_just_pressed("jump") and player.can_jump():
		state_machine.change_state(state_machine.get_node("Jump"))
		return
		
	if player.is_on_floor():
		player.jump_cont = 0
		if player.velocity.x == 0:
			state_machine.change_state(state_machine.get_node("Idle"))
		else:
			state_machine.change_state(state_machine.get_node("Walk"))
		return
		
	if (player.left_wall_detected.is_colliding() or player.right_wall_detected.is_colliding()) and player.is_on_wall():
		state_machine.change_state(state_machine.get_node("Wall"))
		return
		
	if Input.is_action_just_pressed("attack") and player.can_attack():
		state_machine.change_state(state_machine.get_node("Attack"))
		return
