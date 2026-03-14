extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var enemy_health = 3 # Exemplo: 3 tiros de neve para morrer

var speed = 70
var direction = 1
var exploded = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not exploded:
		position.x += speed * delta * direction
	
func set_direction(player_direction):
	self.direction = player_direction
	anim.flip_h = direction < 0

func take_damage(amount: int = 1):
	enemy_health -= amount
	# Adicione um efeito visual aqui, como piscar em vermelho
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if enemy_health <= 0:
		queue_free() # Inimigo morre
func explodir_bola():
	exploded = true
	speed = 0
	$CollisionShape2D.set_deferred("disabled", true)
	anim.play("explode")
	
func _on_area_entered(area: Area2D) -> void:
	if exploded: return 
	
	# IMPORTANTE: Usamos o 'owner' para garantir que, não importa qual área
	# da snowball atinja (Head ou Body), o dano vá para o script do Minotauro 
	var alvo = area.owner
	if alvo and alvo.has_method("take_damage"):
		alvo.take_damage(20)
		explodir_bola()
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "explode":
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	# Se o corpo que ela tocou for o Player, ela ignora e continua
	if body is CharacterBody2D: 
		return 
	queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
