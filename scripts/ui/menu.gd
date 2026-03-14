extends Control
class_name Menu

func _ready() -> void:
	
	get_tree().paused = true

func _on_começar_pressed() -> void:
	# Usando o nosso Singleton perfeito!
	SceneManager.change_scene(SceneManager.Scenes.FASE_1)

func _on_opcao_pressed() -> void:
	# Trocando de cena com segurança
	SceneManager.change_scene(SceneManager.Scenes.OPCAO)

func _on_sair_pressed() -> void:
	get_tree().quit()
