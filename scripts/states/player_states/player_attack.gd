class_name PlayerAttackState
extends PlayerState

func enter() -> void:
	super.enter()
	player.anim.play("attack")
	player.velocity.x = 0
	player.state_just_entered = true

func physics_update(delta: float) -> void:
	player.move(delta)
	
	if player.state_just_entered:
		player.state_just_entered = false
		player.mana -= 10
		player.emit_signal("player_stats_changed", player)
		player.throw_snow()
		player.ball.play()
		player.shoot_timer.start(0.4)

	if Input.is_action_just_pressed("attack") and player.can_attack():
		state_machine.change_state(state_machine.get_node("Attack"))
