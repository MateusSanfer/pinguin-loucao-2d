class_name HitboxComponent
extends Area2D

## Componente que recebe dano e repassa para o HealthComponent associado.

@export var health_component: HealthComponent

func _ready() -> void:
	if not health_component:
		push_warning("HitboxComponent em " + owner.name + " não tem um HealthComponent associado!")

func damage(amount: float) -> void:
	if health_component:
		health_component.take_damage(amount)
