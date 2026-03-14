class_name PlayerWalkState
extends PlayerState

func enter() -> void:
	super.enter()
	player.anim.play("walk")

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move(delta)
	if player.velocity.x == 0:
		state_machine.change_state(state_machine.get_node("Idle"))
		return
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(state_machine.get_node("Jump"))
		return
	if Input.is_action_just_pressed("duck"):
		state_machine.change_state(state_machine.get_node("Slide"))
		return
	if Input.is_action_just_pressed("attack") and player.can_attack():
		state_machine.change_state(state_machine.get_node("Attack"))
		return
	if Input.is_action_just_pressed("meeleAttack") and player.can_meele_attack():
		state_machine.change_state(state_machine.get_node("MeeleAttack"))
		return
	if not player.is_on_floor():
		player.jump_cont += 1
		state_machine.change_state(state_machine.get_node("Fall"))
		return
