extends CharacterBody2D

enum MinotauroState { 
	walk, 
	attack, 
	hurt 
	}

@onready var head_hitbox: Area2D = $Visual/HeadHitbox
@onready var body_hitbox: Area2D = $Visual/BodyHitbox
@onready var hitbox_red: Area2D = $Visual/HitboxRed
@onready var wall_detector: RayCast2D = $Visual/WallDetector
@onready var ground_detector: RayCast2D = $Visual/GroundDetector
@onready var anim: AnimatedSprite2D = $Visual/AnimatedSprite2D
@onready var visual_node: Node2D = $Visual 
@onready var self_destruct_timer_minotauro: Timer = $SelfDestructTimer
@onready var risada: AudioStreamPlayer = $risada

@export var jump_damage := 30.0 # Cada inimigo pode ter um valor diferente no Inspetor

var status: MinotauroState = MinotauroState.walk
const SPEED = 20.0 
@onready var health_component: HealthComponent = $HealthComponent

var direction = 1
var can_throw = true
var player: Node2D = null
var is_chasing = false
var can_attack = false

func _ready() -> void:
	# A Hitbox da espada começa totalmente desligada 
	hitbox_red.monitoring = false
	hitbox_red.monitorable = false
	
	# A Hitbox do corpo deve estar SEMPRE pronta para receber dano 
	body_hitbox.monitoring = false
	body_hitbox.monitorable = true 
	
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
		health_component.died.connect(go_to_hurt_state)
		
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		MinotauroState.walk:
			walk_state(delta)
		MinotauroState.attack:
			attack_state(delta)
		MinotauroState.hurt:
			hurt_state(delta)
		
	move_and_slide()

func go_to_walk_state():
	status = MinotauroState.walk
	anim.play("walk")
	# GARANTIA: O Player não consegue detectar esta área agora 
	hitbox_red.monitoring = false
	hitbox_red.monitorable = false
	
func go_to_attack_state():
	
	status = MinotauroState.attack
	anim.play("attack")
	velocity.x = 0
	can_throw = true
	risada.play()
	
func go_to_hurt_state():
		status = MinotauroState.hurt
		anim.play("hurt")
		disable_hitboxes()
		velocity = Vector2.ZERO
		
		self_destruct_timer_minotauro.start()

func walk_state(_delta):
	if is_chasing and player:
		var distance_x = player.global_position.x - global_position.x
		direction = 1 if distance_x > 0 else -1
		update_facing()

		if can_attack:
			go_to_attack_state()
		else:
			# Só andamos se NÃO estamos atacando
			velocity.x = SPEED * direction
	else:
		# Patrulha
		velocity.x = SPEED * direction
		if wall_detector.is_colliding() or not ground_detector.is_colliding():
			direction *= -1
			update_facing()

func attack_state(delta):
	# Freio ABS: Reduz a velocidade do knockback rapidamente até 0
	velocity.x = move_toward(velocity.x, 0, 400 * delta)
	
	# Liga apenas no frame de impacto (3 até o 5) 
	if anim.frame >= 3 and anim.frame <= 5 and can_throw: 
		hitbox_red.monitoring = true
		hitbox_red.monitorable = true # Agora o Player pode "sentir" o golpe
	elif anim.frame > 5:
		hitbox_red.monitoring = false
		hitbox_red.monitorable = false
		can_throw = false # Impede de ligar novamente na mesma animação
			
func hurt_state(_delta):
	pass

func take_damage(amount: float = 20.0):
	if health_component:
		health_component.take_damage(amount)

func _on_health_changed(current: float, max: float):
	# Knockback no Minotauro:
	var knockback_force = 100.0
	velocity.x = (1 if player == null or player.global_position.x < global_position.x else -1) * knockback_force
	
	# Efeito visual de dano
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE

func update_facing():
	visual_node.scale.x = direction

func disable_hitboxes():
	head_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	body_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
# --- SINAIS ---
func die_instantly():
	if health_component:
		health_component.take_damage(9999)

func _on_agro_area_body_entered(body):
	if body.name == "player":
		player = body
		is_chasing = true

func _on_agro_area_body_exited(body):
	if body == player:
		is_chasing = false
		player = null

func _on_attack_range_body_entered(body):
	if body.name == "player":
		can_attack = true

func _on_attack_range_body_exited(body):
	if body.name == "player":
		can_attack = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if status == MinotauroState.attack:
		hitbox_red.monitoring = false
		hitbox_red.monitorable = false # Desliga ao terminar 
		
		if not is_chasing or player == null:
			go_to_walk_state()
			return

		if can_attack:
			go_to_attack_state()
		else:
			go_to_walk_state()


func _on_self_destruct_timer_timeout() -> void:
	queue_free()
