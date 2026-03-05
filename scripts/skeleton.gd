extends CharacterBody2D

enum SkeletonState{
	walk,
	attack,
	hurt
}


const SPINNING_BONE = preload("uid://vrjow33shl5h")

@onready var self_destruct_timer_skeleton: Timer = $SelfDestructTimer
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var head_hitbox: Area2D = $HeadHitbox
@onready var body_hitbox: Area2D = $BodyHitbox
@onready var wall_detctor: RayCast2D = $WallDetctor
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var bone_start_position: Node2D = $BoneStartPosition

@export var jump_damage := 30.0 # Cada inimigo pode ter um valor diferente no Inspetor

const SPEED = 7.0
const JUMP_VELOCITY = -400.0
var health := 40.0

var status: SkeletonState

var direction = 1
var can_throw = true

func _ready() -> void:
	go_to_walk_state()
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		SkeletonState.walk:
			walk_state(delta)
		SkeletonState.attack:
			attack_state(delta)
		SkeletonState.hurt:
			hurt_state(delta)

	move_and_slide()
	
func go_to_walk_state():
	status = SkeletonState.walk
	anim.play("walk")
	
func go_to_attack_state():
	status = SkeletonState.attack
	anim.play("attack")
	velocity = Vector2.ZERO
	can_throw = true
	

func go_to_hurt_state():
	status = SkeletonState.hurt
	anim.play("hurt")
	disable_hitboxes()
	velocity = Vector2.ZERO
	
	self_destruct_timer_skeleton.start()
	
func walk_state(_delta):
	if anim.frame == 3 or anim.frame == 4:
		velocity.x = SPEED * direction
	else:
		velocity.x = 0
	
	if wall_detctor.is_colliding():
		scale.x *= -1
		direction *= -1

	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if player_detector.is_colliding():
		go_to_attack_state()
		return
		
func attack_state(_delta):
	if anim.frame == 2 && can_throw:
		throw_bone()
		can_throw = false
	
func hurt_state(_delta):
	pass

func disable_hitboxes():
	head_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	body_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	
func take_damage(amount: float = 20.0):
	health -= amount
	if health <= 0:
		go_to_hurt_state() # Ativa a animação de morte e o timer 

func throw_bone():
	var new_bone = SPINNING_BONE.instantiate()
	add_sibling(new_bone)
	new_bone.position = bone_start_position.global_position
	new_bone.set_direction(self.direction)
	
# Esta função será chamada apenas pelo player ao pular na cabeça
func die_instantly():
	health = 0
	go_to_hurt_state()
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		go_to_walk_state()
		return

func _on_self_destruct_timer_skeleton_timeout() -> void:
	queue_free()
