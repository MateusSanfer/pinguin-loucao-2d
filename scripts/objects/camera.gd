extends Camera2D

var target: Node2D
var shake_intensity: float = 0.0 # A câmera agora controla o próprio tremor

func _ready() -> void:
	get_target()
	
func _process(delta: float) -> void:
	# 1. Segue o jogador
	if target:
		position = target.position

	# 2. Lógica do Tremor (Screen Shake)
	if shake_intensity > 0:
		offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		shake_intensity = lerp(shake_intensity, 0.0, 10 * delta)
	else:
		offset = Vector2.ZERO

func get_target():
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() == 0:
		push_error("Jogador não encontrado!")
		return
	target = nodes[0]

# O Pinguim vai chamar essa função quando der a martelada!
func apply_shake(intensity: float):
	shake_intensity = intensity
