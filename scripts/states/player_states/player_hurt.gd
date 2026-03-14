class_name PlayerHurtState
extends PlayerState

func enter() -> void:
	super.enter()
	player.anim.play("hurt")
	
	if player.health <= 0:
		player.velocity.x = 0
		player.reload_timer.start()
	else:
		# Aumente este valor (de 50 para 250 ou 300) para um impacto imediato
		# O sinal negativo inverte a direção que o player está olhando
		player.velocity.x = -player.facing_direction * 10 
		# Adicione um pequeno empurrão para cima também para tirar o player do chão
		player.velocity.y = -20 
		
		# Diminua o tempo do Timer para 0.2s para o controle voltar mais rápido
		await player.get_tree().create_timer(0.2).timeout 
		
		if player.health > 0:
			if player.is_on_floor():
				state_machine.change_state(state_machine.get_node("Idle"))
			else:
				state_machine.change_state(state_machine.get_node("Fall"))

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()
