class_name PlayerIdleState
extends PlayerState

func enter() -> void:
	super.enter()
	player.anim.play("idle")

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move(delta)
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(state_machine.get_node("Jump"))
		return
	if player.velocity.x != 0:
		state_machine.change_state(state_machine.get_node("Walk"))
		return
	if Input.is_action_pressed("duck"):
		state_machine.change_state(state_machine.get_node("Duck"))
		return
	if Input.is_action_just_pressed("attack") and player.can_attack():
		state_machine.change_state(state_machine.get_node("Attack"))
		return
	if Input.is_action_just_pressed("meeleAttack") and player.can_meele_attack():
		state_machine.change_state(state_machine.get_node("MeeleAttack"))
		return
