class_name HealthComponent
extends Node

signal health_changed(current_health: float, max_health: float)
signal damaged(amount: float)
signal died()

@export var max_health: float = 100.0
var health: float

func _ready() -> void:
	health = max_health

func take_damage(amount: float) -> void:
	health -= amount
	emit_signal("damaged", amount)
	emit_signal("health_changed", health, max_health)
	
	if health <= 0:
		emit_signal("died")

func heal(amount: float) -> void:
	health += amount
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health, max_health)

func set_max_health(new_max: float) -> void:
	max_health = new_max
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health, max_health)
