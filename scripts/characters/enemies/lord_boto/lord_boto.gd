extends CharacterBody2D

enum LordBotoState { 
	walk, 
	hurt,
	attack_slash_oversize
	}
	
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var body_hitbox: HitboxComponent = $BodyHitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var self_destruct_timer: Timer = $SelfDestructTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_hurtbox: Area2D = $AnimatedSprite2D/HitboxSlash
@onready var player_detector: RayCast2D = $AnimatedSprite2D/PlayerDetector
@onready var player_detector_2: RayCast2D = $AnimatedSprite2D/PlayerDetector2

const SPEED = 40.0
const JUMP_VELOCITY = -400.0

var status: LordBotoState = LordBotoState.walk

var direction = 1
var can_throw = true

func _ready() -> void:
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
		health_component.died.connect(go_to_hurt_state)
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	match status:
		LordBotoState.walk:
			walk_state(delta)
		LordBotoState.attack_slash_oversize:
			attack_slash_state(delta)
		LordBotoState.hurt:
			hurt_state(delta)
			
	move_and_slide()
	
func go_to_walk_state():
	status = LordBotoState.walk
	anim.play("walk")
	attack_hurtbox.set_deferred("monitoring", false)
	attack_hurtbox.set_deferred("monitorable", false)
	
func go_to_attack_slash_state():
	status = LordBotoState.attack_slash_oversize
	anim.play("attack_slash_oversize")
	velocity = Vector2.ZERO
	can_throw = true
	attack_hurtbox.set_deferred("monitoring", false)
	attack_hurtbox.set_deferred("monitorable", false)
	
func go_to_hurt_state():
	status = LordBotoState.hurt
	anim.play("hurt")
	disable_hitboxes()
	velocity = Vector2.ZERO
	
	self_destruct_timer.start()
	
func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding() or not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if player_detector_2.is_colliding():
		scale.x *= -1
		direction *= -1
		go_to_attack_slash_state()
		return
	elif player_detector.is_colliding():
		go_to_attack_slash_state()
		return
		
func attack_slash_state(_delta):
	# O Frame 2 é quando a espada desce, ligamos o monitoramento da shape da Hitbox
	if anim.frame == 2 and can_throw:
		attack_hurtbox.set_deferred("monitoring", true)
		attack_hurtbox.set_deferred("monitorable", true)
	elif anim.frame > 2:
		attack_hurtbox.set_deferred("monitoring", false)
		attack_hurtbox.set_deferred("monitorable", false)
		can_throw = false
		
	# No último frame da animação (5), ele volta a andar
	if anim.frame >= 5:
		go_to_walk_state()
	
func hurt_state(_delta):
	pass

func disable_hitboxes():
	body_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	attack_hurtbox.set_deferred("monitoring", false)
	attack_hurtbox.set_deferred("monitorable", false)

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

func _on_self_destruct_timer_timeout():
	queue_free()
