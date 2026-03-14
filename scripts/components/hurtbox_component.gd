class_name HurtboxComponent
extends Area2D

## Componente que causa dano ao encostar em um HitboxComponent.

@export var damage_amount: float = 20.0

func _ready() -> void:
	# Conecta o sinal de área que entrou para causar dano
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		area.damage(damage_amount)
