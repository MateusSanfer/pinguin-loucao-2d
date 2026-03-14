class_name PlayerMeeleAttackState
extends PlayerState

func enter() -> void:
	super.enter()
	player.velocity.x = 0
	player.anim.visible = false
	player.meele_sprite.visible = true
	player.animator.play("meeleAttack")
	player.state_just_entered = true
	player.hitbox_meele.monitoring = true 
	player.mana -= 15
	player.emit_signal("player_stats_changed", player)

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
