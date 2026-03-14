class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var entity: CharacterBody2D

func _ready() -> void:
	# O StateMachine e os States esperam estar como filhos de um CharacterBody2D
	entity = get_parent() as CharacterBody2D
	
	for child in get_children():
		if child is State:
			child.state_machine = self
			child.entity = entity
			
	if initial_state:
		# Aguarda o primeiro frame para ter certeza que tudo no owner inicializou
		call_deferred("change_state", initial_state)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
		
	current_state = new_state
	new_state.enter()
