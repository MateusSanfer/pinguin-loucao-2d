extends Control
class_name Opcao

func _on_voltar_pressed() -> void:
	# Volta para o menu usando a transição segura do SceneManager
	SceneManager.change_scene(SceneManager.Scenes.MENU)

func _on_resolucao_pressed() -> void:
	pass

func _on_volume_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scenes.VOLUME)
