class_name PlayerDuckState
extends PlayerState

func enter() -> void:
	super.enter()
	player.anim.play("duck")
	player.set_small_collider()

func exit() -> void:
	player.set_large_collider()

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.update_direction()
	if Input.is_action_just_released("duck"):
		state_machine.change_state(state_machine.get_node("Idle"))
		return
