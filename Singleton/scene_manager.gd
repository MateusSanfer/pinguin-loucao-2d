extends Node

enum Scenes {
	MENU,
	FASE_1,
	FASE_2,
	FASE_3,
	OPCAO,
	VOLUME,
}

const SCENE_PATHS = {
	Scenes.MENU: "res://scenes/ui/menu.tscn",
	Scenes.FASE_1: "res://scenes/levels/winter.tscn",
	Scenes.FASE_2: "res://scenes/levels/tropic.tscn",
	Scenes.FASE_3: "res://scenes/levels/forest.tscn",
	Scenes.OPCAO: "res://scenes/ui/opcao.tscn",
	Scenes.VOLUME: "res://scenes/ui/controle_volume.tscn",
}

# Guarda a cena anterior para navegação dinâmica do botão "Voltar"
var previous_scene: Scenes = Scenes.MENU

func change_scene(scene: Scenes):
	if not SCENE_PATHS.has(scene):
		push_error("SceneManager: Cena não definida no SCENE_PATHS!")
		return
	
	# Guarda a cena atual como "anterior" antes de trocar
	var current_path = get_tree().current_scene.scene_file_path
	for key in SCENE_PATHS:
		if SCENE_PATHS[key] == current_path:
			previous_scene = key
			break
	
	# Força despause antes de mudar de cena
	get_tree().paused = false
	
	var err = get_tree().change_scene_to_file(SCENE_PATHS[scene])
	if err != OK:
		push_error("SceneManager: Falha ao carregar: ", SCENE_PATHS[scene])

func go_back():
	change_scene(previous_scene)
