extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump,
	fall,
	duck,
	slide,
	wall,
	hurt,
	swimming,
	attack
}
const SNOWBALL = preload("uid://cpxfsv1j5q5id")
@onready var attack_start_position: Marker2D = $AttackStartPosition

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var left_wall_detected: RayCast2D = $LeftWallDetected
@onready var right_wall_detected: RayCast2D = $RightWallDetected
@onready var reload_timer: Timer = $ReloadTimer
@onready var shoot_timer: Timer = $ShootTimer

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
var health :=  100.0
var max_health := 100.0
var health_recovery := 2.5
var mana :=  100.0
var max_mana := 100.0
var mana_recovery := 3.5

var state_just_entered = false

func _process(delta: float) -> void:
	var new_mana = min(mana + mana_recovery * delta, max_mana)
	if new_mana != mana:
		mana = new_mana
		emit_signal("player_stats_changed", self)
		
	var new_health = min(health + health_recovery * delta, max_health)
	if new_health != health:
		health = new_health
		emit_signal("player_stats_changed", self)
		

signal player_stats_changed

var facing_direction = 1 # Começa olhando para a direita
var jump_cont = 0
@export var max_jump_cont = 2
var direction = 0
var status: PlayerState
		
func _ready() -> void:
	go_to_idle_state()
	emit_signal("player_stats_changed",self)

func _physics_process(delta: float) -> void:
	
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.duck:
			duck_state(delta)
		PlayerState.fall:
			fall_state(delta)
		PlayerState.slide:
			slide_state(delta)
		PlayerState.hurt:
			hurt_state(delta)
		PlayerState.attack:
			attack_state(delta)
		PlayerState.wall:
			wall_state(delta)
		PlayerState.swimming:
			swimming_state(delta)
			
	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")
	
func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")

func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_cont += 1
	
func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall")
	
func go_to_duck_state():
	status = PlayerState.duck
	anim.play("duck")
	set_small_collider()

func exit_from_duck_state():
	set_large_collider()
	
func go_to_slide_state():
	status = PlayerState.slide
	anim.play("slide")
	set_small_collider()

func exit_from_slide_state():
	set_large_collider()
	
func go_to_wall_state():
	status = PlayerState.wall
	anim.play("wall")
	velocity = Vector2.ZERO
	
func go_to_swimming_state():
	status = PlayerState.swimming
	anim.play("swimming")
	velocity.y = min(velocity.y, 180)
	
func go_to_hurt_state():
	if status == PlayerState.hurt:
		return
	status = PlayerState.hurt
	anim.play("hurt")
	velocity.x = 0
	reload_timer.start()
	
func go_to_attack_state():
	status = PlayerState.attack
	anim.play("attack")
	velocity.x = 0
	state_just_entered = true
		
func idle_state(delta):
	apply_gravity(delta)
	move(delta)
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
	if velocity.x != 0:
		go_to_walk_state()
		return
		
	if Input.is_action_pressed("duck"):
		go_to_duck_state()
		return
	if Input.is_action_just_pressed("attack") and can_attack():
		go_to_attack_state()
		return
	
func walk_state(delta):
	apply_gravity(delta)
	move(delta)
	if velocity.x == 0:
		go_to_idle_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	if Input.is_action_just_pressed("duck"):
		go_to_slide_state()
		return
	if Input.is_action_just_pressed("attack") and can_attack():
		go_to_attack_state()
		return
	
	if !is_on_floor():
		# Impede de pular mais de uma vez caso tenha caido.
		jump_cont += 1
		go_to_fall_state()
		return
		
# Essa função dessa forma torna o pulo infinito, bom para jogos estilo Flep beard.
func jump_state(delta):
	apply_gravity(delta)
	move(delta)
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	if velocity.y >0:
		go_to_fall_state()
		return
	if Input.is_action_just_pressed("attack") and can_attack():
		go_to_attack_state()
		return

func fall_state(delta):
	apply_gravity(delta)
	move(delta)
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		
	if is_on_floor():
		jump_cont = 0
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return
		
	if (left_wall_detected.is_colliding() or right_wall_detected.is_colliding()) && is_on_wall():
		go_to_wall_state()
		return
		
	if Input.is_action_just_pressed("attack") and can_attack():
		go_to_attack_state()
		return
	
func duck_state(delta):
	apply_gravity(delta)
	update_direction()
	if Input.is_action_just_released("duck"):
		exit_from_duck_state()
		go_to_idle_state()
		return
		
func slide_state(delta):
	apply_gravity(delta)
	velocity.x = move_toward(velocity.x, 0, slide_decceleration * delta)
	
	if Input.is_action_just_released("duck"):
		exit_from_slide_state()
		go_to_walk_state()
		return
	if velocity.x == 0:
		exit_from_slide_state()
		go_to_duck_state()
		return

func wall_state(delta):
	
	velocity.y += wall_acceleration * delta
	
	if left_wall_detected.is_colliding():
		anim.flip_h = false
		direction = 1
	elif right_wall_detected.is_colliding():
		anim.flip_h = true
		direction = -1
	else:
		go_to_fall_state()
		return
		
	if is_on_floor():
		go_to_idle_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		velocity.x = wall_jump_velocity * direction
		go_to_jump_state()
		return
		
func swimming_state(delta):
	update_direction()
	
	if direction:
		velocity.x = move_toward(velocity.x, water_max_speed * direction, water_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, water_acceleration * delta)
		
	velocity.y += water_acceleration * delta
	velocity.y = min(velocity.y, water_max_speed)
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = water_jump_force
	
func hurt_state(delta):
	apply_gravity(delta)
	
func attack_state(delta):
	move(delta)

	if state_just_entered:
		state_just_entered = false
		mana -= 10
		emit_signal("player_stats_changed", self)
		throw_snow()
		shoot_timer.start(0.4)

	# Permitir novo ataque ainda no ar
	if Input.is_action_just_pressed("attack") and can_attack():
		go_to_attack_state()
		
func can_attack() -> bool:
	return mana >= 10 and shoot_timer.is_stopped()

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
	
	if direction < 0:
		anim.flip_h = true
		facing_direction = -1 # Guarda que o player está virado para a esquerda
		attack_start_position.position.x = -abs(attack_start_position.position.x)
	elif direction > 0:
		anim.flip_h = false
		facing_direction = 1 # Guarda que o player está virado para a direita
		attack_start_position.position.x = abs(attack_start_position.position.x)
		
func can_jump() -> bool:
	return jump_cont < max_jump_cont
	
func set_small_collider():
	collision_shape.shape.radius = 5
	collision_shape.shape.height = 10
	collision_shape.position.y = 3
	
	hitbox_collision_shape.shape.size.y = 10
	hitbox_collision_shape.position.y = 3
	
func set_large_collider():
	collision_shape.shape.radius = 6
	collision_shape.shape.height = 16
	collision_shape.position.y = 0
	
	hitbox_collision_shape.shape.size.y = 15
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

	if area.is_in_group("EnemiesAttack"):
		take_damage(20)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("LethalArea"):
		go_to_hurt_state()
	elif body.is_in_group("Water"):
		go_to_swimming_state()
		
func take_damage(amount: float):
	if status == PlayerState.hurt:
		return
		
	health -= amount
	emit_signal("player_stats_changed", self) 
	
	if health <= 0:
		go_to_hurt_state() 
	else:
		status = PlayerState.hurt
		anim.play("hurt") 
		
		# Aumente este valor (de 50 para 250 ou 300) para um impacto imediato
		# O sinal negativo inverte a direção que o player está olhando
		velocity.x = -facing_direction * 10 
		# Adicione um pequeno empurrão para cima também para tirar o player do chão
		velocity.y = -20 
		
		# Diminua o tempo do Timer para 0.2s para o controle voltar mais rápido
		await get_tree().create_timer(0.2).timeout 
		
		if is_on_floor():
			go_to_idle_state() 
		else:
			go_to_fall_state()
	
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
	if status == PlayerState.hurt:
		return
	go_to_hurt_state()

func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()

# Conecte o sinal animation_finished do AnimatedSprite2D para voltar ao idle
func _on_animated_sprite_2d_animation_finished():
	if status == PlayerState.attack:
		if is_on_floor():
			go_to_idle_state()
		else:
			go_to_fall_state()

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Water"):
		jump_cont= 0
		go_to_jump_state()
