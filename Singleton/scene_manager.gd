extends Node

enum Scenes {
	MENU,
	FASE_1,
	FASE_2,
	FASE_3,
	OPCAO,
}

# --- MUITO IMPORTANTE: ALTERE OS CAMINHOS ABAIXO ---
# Eu não sei onde seus arquivos estão. Você PRECISA ir no Sistema de Arquivos (FileSystem),
# clicar com o botão direito em cada uma de suas cenas (.tscn), escolher "Copiar Caminho"
# e colar entre as aspas abaixo.
const SCENE_PATHS = {
	Scenes.MENU: "res://scenes/ui/menu.tscn",   # Cole o caminho real do seu Menu aqui
	Scenes.FASE_1: "res://scenes/levels/winter.tscn", # Cole o caminho real da sua Fase 1 aqui
	Scenes.FASE_2: "res://scenes/levels/tropic.tscn",  # Cole o caminho real da sua Fase 2 aqui
	Scenes.FASE_3: "res://scenes/levels/forest.tscn",  # Cole o caminho real da sua Fase 2 aqui
	Scenes.OPCAO: "res://scenes/ui/opcao.tscn", # Cole o caminho real da sua cena Opção aqui
}

# Função auxiliar Crucial para o conserto dos botões travarem
func _unpause_engine():
	get_tree().paused = false

func change_scene(scene: Scenes):
	# Verificação de segurança
	if not SCENE_PATHS.has(scene):
		push_error("SceneManager: A cena tentada carregar não está definida no dicionário SCENE_PATHS!")
		return
		# A marretada final: Sempre força o despause antes de mudar de cena
	get_tree().paused = false 
	get_tree().change_scene_to_file(SCENE_PATHS[scene])
	print("Cena carregada!")
	
	# --- REMOVIDO: Toda a lógica de transição que você não tem os arquivos ---

	# --- LIMPEZA OBRIGATÓRIA (Conserto do Bug dos Botões) ---
	# Antes de trocar de arquivo de cena, garantimos que o motor do Godot
	# NÃO está pausado globalmente. Isso corrige o bug dos botões travarem.
	_unpause_engine()
	# -----------------------------------------------------------

	var err = get_tree().change_scene_to_file(SCENE_PATHS[scene])
	if err != OK:
		push_error("SceneManager: Falha ao carregar a cena: ", SCENE_PATHS[scene], ". Verifique se o caminho no SCENE_PATHS está correto.")
