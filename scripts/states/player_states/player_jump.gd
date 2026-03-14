class_name PlayerJumpState
extends PlayerState

func enter() -> void:
	super.enter()
	player.anim.play("jump")
	player.velocity.y = player.JUMP_VELOCITY
	player.jump_cont += 1
	player.jump.play()

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move(delta)
	if Input.is_action_just_pressed("jump") and player.can_jump():
		state_machine.change_state(state_machine.get_node("Jump"))
		return
	if player.velocity.y > 0:
		state_machine.change_state(state_machine.get_node("Fall"))
		return
	if Input.is_action_just_pressed("attack") and player.can_attack():
		state_machine.change_state(state_machine.get_node("Attack"))
		return
