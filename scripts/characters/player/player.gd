class_name Player
extends CharacterBody2D

const SNOWBALL = preload("uid://cpxfsv1j5q5id")
@onready var attack_start_position: Marker2D = $AttackStartPosition

@onready var animator: AnimationPlayer = $animator
@onready var meele_sprite: Sprite2D = $MeelePivot/Sprite2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var left_wall_detected: RayCast2D = $LeftWallDetected
@onready var right_wall_detected: RayCast2D = $RightWallDetected
@onready var reload_timer: Timer = $ReloadTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var meele_pivot: Node2D = $MeelePivot
@onready var hitbox_meele: Area2D = $MeelePivot/HitboxMeele
@onready var ball: AudioStreamPlayer = $Ball
@onready var jump: AudioStreamPlayer = $jump

@onready var health_component: HealthComponent = $HealthComponent
@export var max_speed = 110.0
@export var acceleration = 260.0
@export var decceleration = 260.0
@export var slide_decceleration = 100.0
@export var wall_acceleration = 40.0
@export var wall_jump_velocity = 140.0
@export var water_max_speed = 100.0
@export var water_acceleration = 200.0
@export var water_jump_force =  -100.0

const JUMP_VELOCITY = -300.0

# Estatísticas do Player
var health: float:
	get:
		return health_component.health if health_component else 100.0
	set(value):
		if health_component:
			health_component.health = value
			
var max_health: float:
	get:
		return health_component.max_health if health_component else 100.0
	set(value):
		if health_component:
			health_component.max_health = value
			
var health_recovery := 1.5
var mana :=  100.0
var max_mana := 100.0
var mana_recovery := 3.5

var state_just_entered = false
var is_attacking = true

func _process(delta: float) -> void:
	# Lógica de Mana e Vida
	var new_mana = min(mana + mana_recovery * delta, max_mana)
	if new_mana != mana:
		mana = new_mana
		emit_signal("player_stats_changed", self)
		
	var new_health = min(health + health_recovery * delta, max_health)
	if new_health != health:
		if health_component:
			health_component.heal(health_recovery * delta)
		
signal player_stats_changed

var facing_direction = 1 # Começa olhando para a direita
var jump_cont = 0
@export var max_jump_cont = 2
var direction = 0

@onready var state_machine: StateMachine = $StateMachine
		
func _ready() -> void:
	# Força a área do martelo a começar desligada
	hitbox_meele.monitoring = false
	if health_component:
		health_component.health_changed.connect(func(c, m): emit_signal("player_stats_changed", self))
		health_component.damaged.connect(func(_amt): go_to_hurt_state())
		health_component.died.connect(go_to_hurt_state)
	# go_to_idle já é acionado pela inicialização da StateMachine
	emit_signal("player_stats_changed",self)

func _physics_process(delta: float) -> void:
	move_and_slide()

func go_to_idle_state():
	if state_machine:
		state_machine.change_state(state_machine.get_node("Idle"))
	
func go_to_walk_state():
	if state_machine:
		state_machine.change_state(state_machine.get_node("Walk"))

func go_to_jump_state():
	if state_machine:
		state_machine.change_state(state_machine.get_node("Jump"))
	
func go_to_fall_state():
	if state_machine:
		state_machine.change_state(state_machine.get_node("Fall"))
	
func go_to_duck_state():
	if state_machine:
		state_machine.change_state(state_machine.get_node("Duck"))

func exit_from_duck_state():
	set_large_collider()
	
func go_to_slide_state():
	if state_machine:
		state_machine.change_state(state_machine.get_node("Slide"))

func exit_from_slide_state():
	set_large_collider()
	
func go_to_wall_state():
	if state_machine:
		state_machine.change_state(state_machine.get_node("Wall"))
	
func go_to_swimming_state():
	if state_machine:
		state_machine.change_state(state_machine.get_node("Swimming"))
	
func go_to_hurt_state():
	if state_machine and state_machine.current_state and state_machine.current_state.name.to_lower() == "hurt":
		return
	if state_machine:
		state_machine.change_state(state_machine.get_node("Hurt"))
	
func go_to_attack_state():
	if state_machine:
		state_machine.change_state(state_machine.get_node("Attack"))
		
func go_to_meeleAttack_state():
	if state_machine:
		state_machine.change_state(state_machine.get_node("MeeleAttack"))

func can_attack() -> bool:
	return mana >= 10 and shoot_timer.is_stopped()
	
func can_meele_attack() -> bool:
	return mana >= 15 # Só ataca se tiver 15 ou mais de mana
	
func move(delta):
	update_direction()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, decceleration * delta)
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func update_direction():
	direction = Input.get_axis("left", "right")
	
	# Só atualizamos a direção se o jogador estiver apertando algo
	if direction != 0:
		facing_direction = direction # Será -1 ou 1
		
		# ESTA LINHA FAZ A MÁGICA:
		# Ela vira o desenho do martelo E a hitbox ao mesmo tempo sem bugar a animação!
		$MeelePivot.scale.x = direction 
		
		# O pinguim (anim) continua usando flip_h
		anim.flip_h = direction < 0
		
		# A posição da bola de neve continua sendo ajustada manualmente
		attack_start_position.position.x = abs(attack_start_position.position.x) * direction
		
func can_jump() -> bool:
	return jump_cont < max_jump_cont
	
func set_small_collider():
	collision_shape.shape.radius = 5
	collision_shape.shape.height = 10
	collision_shape.position.y = 2
	
	hitbox_collision_shape.shape.size.y = 10
	hitbox_collision_shape.position.y = 2
	
func set_large_collider():
	collision_shape.shape.radius = 6
	collision_shape.shape.height = 14
	collision_shape.position.y = 0
	
	hitbox_collision_shape.shape.size.y = 14
	hitbox_collision_shape.position.y = 0.5

func throw_snow():
	var new_snow = SNOWBALL.instantiate()
	add_sibling(new_snow)
	new_snow.global_position = attack_start_position.global_position
	# Agora a bola sempre terá direção 1 ou -1, nunca 0!
	new_snow.set_direction(facing_direction)

func _on_hitbox_area_entered(area: Area2D) -> void:
# Detecta se a área é de um ataque inimigo (como a HitboxRed do Minotauro)
	if area.is_in_group("EnemiesAttack"):
		take_damage(20) # Valor do dano do Minotauro/Esqueleto
		
	if area.is_in_group("Enemies"):
		hit_enemy(area)
	elif area.is_in_group("LethalArea"):
		take_damage(100) # Áreas letais ainda matam instantaneamente


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("LethalArea"):
		take_damage(9999)
	elif body.is_in_group("Water"):
		go_to_swimming_state()
		
func take_damage(amount: float):
	if state_machine and state_machine.current_state and state_machine.current_state.name.to_lower() == "hurt":
		return
		
	if health_component:
		health_component.take_damage(amount)
	
	go_to_hurt_state()
	
func hit_enemy(area: Area2D):
	var enemy = area.owner # Pega a raiz do inimigo (Minotauro ou Skeleton)
	
	if velocity.y > 0:
		# Se o inimigo tiver a função de dano
		if enemy and enemy.has_method("take_damage"):
			# Usa o jump_damage personalizado do inimigo, ou 50 como padrão
			var dmg = enemy.get("jump_damage") if "jump_damage" in enemy else 50.0
			enemy.take_damage(dmg)
			go_to_jump_state()
	elif area.is_in_group("enemy_body"):
		take_damage(10)
		

func hit_lethal_area():
	if state_machine and state_machine.current_state and state_machine.current_state.name.to_lower() == "hurt":
		return
	take_damage(9999)

func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()

# Conecte o sinal animation_finished do AnimatedSprite2D para voltar ao idle
func _on_animated_sprite_2d_animation_finished():
	if state_machine and state_machine.current_state and state_machine.current_state.name.to_lower() == "attack":
		if is_on_floor():
			go_to_idle_state()
		else:
			go_to_fall_state()

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Water"):
		jump_cont= 0
		go_to_jump_state()


func _on_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "meeleAttack":
		anim.visible = true
		meele_sprite.visible = false
		
		# DESLIGA o sensor de dano do martelo assim que a animação acaba
		hitbox_meele.set_deferred("monitoring", false)
		
		if is_on_floor():
			go_to_idle_state()
		else:
			go_to_fall_state()


func _on_hitbox_meele_area_entered(area: Area2D) -> void:
	# Agora o log vai aparecer para o Minotauro também!
	print("HitboxMeele encostou em: ", area.name)
	
	if area.is_in_group("Enemies") or area.is_in_group("enemy_body"):
		var enemy = area.owner # Pega o nó raiz do inimigo 
		if enemy and enemy.has_method("take_damage"):
			enemy.take_damage(30) # Martelada pesada!
			# TELA TREME AQUI! (Valor 5.0 a 8.0 é um bom impacto)
			get_tree().call_group("Camera", "apply_shake", 5.0)
			print("Martelada confirmada no ", enemy.name, "!")
