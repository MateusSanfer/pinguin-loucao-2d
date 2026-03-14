extends CharacterBody2D

enum LordBotoState { 
	walk, 
	hurt,
	attack_slash_oversize,
	attack_slash_reverse,
	attack_thrust
	}
	
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var body_hitbox: HitboxComponent = $BodyHitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var self_destruct_timer: Timer = $SelfDestructTimer
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_hurtbox: Area2D = $AnimatedSprite2D/HitboxSlash
@onready var hitbox_reverse: HurtboxComponent = $AnimatedSprite2D/HitboxReverse
@onready var hitbox_thrust: HurtboxComponent = $AnimatedSprite2D/HitboxThrust
@onready var player_detector: RayCast2D = $AnimatedSprite2D/PlayerDetector
@onready var player_detector_2: RayCast2D = $AnimatedSprite2D/PlayerDetector2

const SPEED = 40.0
const JUMP_VELOCITY = -400.0

var status: LordBotoState = LordBotoState.walk
var direction = 1
var can_throw = true
var attack_ready := true

# Lista de ataques disponíveis para seleção aleatória
var available_attacks = [
	LordBotoState.attack_slash_oversize,
	LordBotoState.attack_slash_reverse,
	LordBotoState.attack_thrust
]

func _ready() -> void:
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
		health_component.died.connect(go_to_hurt_state)
	disable_all_attack_hitboxes()
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	match status:
		LordBotoState.walk:
			walk_state(delta)
		LordBotoState.attack_slash_oversize:
			attack_slash_state(delta)
		LordBotoState.attack_slash_reverse:
			attack_reverse_state(delta)
		LordBotoState.attack_thrust:
			attack_thrust_state(delta)
		LordBotoState.hurt:
			hurt_state(delta)
			
	move_and_slide()

# --- ESTADOS ---

func go_to_walk_state():
	status = LordBotoState.walk
	anim.scale.x = abs(anim.scale.x)
	anim.play("walk")
	disable_all_attack_hitboxes()
	
func go_to_attack_slash_state():
	status = LordBotoState.attack_slash_oversize
	anim.play("attack_slash_oversize")
	velocity = Vector2.ZERO
	can_throw = true
	disable_all_attack_hitboxes()

func go_to_attack_reverse_state():
	status = LordBotoState.attack_slash_reverse
	anim.scale.x = -abs(anim.scale.x)
	anim.play("attack_slash_reverse")
	velocity = Vector2.ZERO
	can_throw = true
	disable_all_attack_hitboxes()

func go_to_attack_thrust_state():
	status = LordBotoState.attack_thrust
	anim.scale.x = -abs(anim.scale.x)
	anim.play("attack_thrust")
	velocity = Vector2.ZERO
	can_throw = true
	disable_all_attack_hitboxes()
	
func go_to_hurt_state():
	status = LordBotoState.hurt
	anim.play("hurt")
	disable_all_attack_hitboxes()
	velocity = Vector2.ZERO
	self_destruct_timer.start()

func choose_attack():
	var chosen = available_attacks[randi() % available_attacks.size()]
	match chosen:
		LordBotoState.attack_slash_oversize:
			go_to_attack_slash_state()
		LordBotoState.attack_slash_reverse:
			go_to_attack_reverse_state()
		LordBotoState.attack_thrust:
			go_to_attack_thrust_state()

# --- LÓGICA DE ESTADOS ---

func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding() or not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
	
	# Só ataca se o cooldown já terminou
	if attack_ready:
		if player_detector_2.is_colliding():
			scale.x *= -1
			direction *= -1
			choose_attack()
			return
		elif player_detector.is_colliding():
			choose_attack()
			return

func attack_slash_state(_delta):
	# Frame 2 = impacto da espada oversized
	if anim.frame == 2 and can_throw:
		attack_hurtbox.set_deferred("monitoring", true)
		attack_hurtbox.set_deferred("monitorable", true)
	elif anim.frame > 2:
		attack_hurtbox.set_deferred("monitoring", false)
		attack_hurtbox.set_deferred("monitorable", false)
		can_throw = false

func attack_reverse_state(_delta):
	# Frame 2 = impacto do corte reverso
	if anim.frame == 2 and can_throw:
		hitbox_reverse.set_deferred("monitoring", true)
		hitbox_reverse.set_deferred("monitorable", true)
	elif anim.frame > 2:
		hitbox_reverse.set_deferred("monitoring", false)
		hitbox_reverse.set_deferred("monitorable", false)
		can_throw = false

func attack_thrust_state(_delta):
	# Frames 4-5 = impacto da estocada
	if anim.frame >= 4 and anim.frame <= 5 and can_throw:
		hitbox_thrust.set_deferred("monitoring", true)
		hitbox_thrust.set_deferred("monitorable", true)
	elif anim.frame > 5:
		hitbox_thrust.set_deferred("monitoring", false)
		hitbox_thrust.set_deferred("monitorable", false)
		can_throw = false

func hurt_state(_delta):
	pass

# --- UTILITÁRIOS ---

func disable_all_attack_hitboxes():
	attack_hurtbox.set_deferred("monitoring", false)
	attack_hurtbox.set_deferred("monitorable", false)
	hitbox_reverse.set_deferred("monitoring", false)
	hitbox_reverse.set_deferred("monitorable", false)
	hitbox_thrust.set_deferred("monitoring", false)
	hitbox_thrust.set_deferred("monitorable", false)

func take_damage(amount: float = 20.0):
	if health_component:
		health_component.take_damage(amount)

func _on_health_changed(current: float, max: float):
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE

func die_instantly():
	if health_component:
		health_component.take_damage(9999)

# --- SINAIS ---

func _on_self_destruct_timer_timeout():
	queue_free()

func _on_attack_cooldown_timeout():
	attack_ready = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if status in [LordBotoState.attack_slash_oversize, LordBotoState.attack_slash_reverse, LordBotoState.attack_thrust]:
		disable_all_attack_hitboxes()
		# Inicia o cooldown antes de poder atacar novamente
		attack_ready = false
		attack_cooldown.start()
		go_to_walk_state()
