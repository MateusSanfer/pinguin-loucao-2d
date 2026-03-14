class_name PlayerSwimmingState
extends PlayerState

func enter() -> void:
	super.enter()
	player.anim.play("swimming")
	player.velocity.y = min(player.velocity.y, 180)

func physics_update(delta: float) -> void:
	player.update_direction()
	if player.direction:
		player.velocity.x = move_toward(player.velocity.x, player.water_max_speed * player.direction, player.water_acceleration * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.water_acceleration * delta)
		
	player.velocity.y += player.water_acceleration * delta
	player.velocity.y = min(player.velocity.y, player.water_max_speed)
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.water_jump_force
