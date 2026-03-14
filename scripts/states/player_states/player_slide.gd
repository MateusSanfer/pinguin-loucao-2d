class_name PlayerSlideState
extends PlayerState

func enter() -> void:
	super.enter()
	player.anim.play("slide")
	player.set_small_collider()

func exit() -> void:
	player.set_large_collider()

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.velocity.x = move_toward(player.velocity.x, 0, player.slide_decceleration * delta)
	if Input.is_action_just_released("duck"):
		state_machine.change_state(state_machine.get_node("Walk"))
		return
	if player.velocity.x == 0:
		state_machine.change_state(state_machine.get_node("Duck"))
		return
