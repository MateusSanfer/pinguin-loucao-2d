extends CanvasLayer

func _ready() -> void:
	# --- BUG FIX: Aparecer automaticamente ---
	# CanvasLayer é controlado por hide() e show().
	# No editor ele pode estar visível, mas aqui forçamos ele a começar escondido.
	hide() 
	
	# Garante que o motor do jogo começa despausado ao carregar a cena principal.
	get_tree().paused = false
	
	# Foca no primeiro botão para controle por teclado/controle
	$MarginContainer/VBoxContainer/Resume.grab_focus()

func _process(_delta: float) -> void:
	# Detecta o input mapeado como "pause" (Esc)
	if Input.is_action_just_pressed("pause"):
		_toggle_pause()

# Função auxiliar para alternar o estado de pause
func _toggle_pause():
	if visible:
		# Se o menu está visível, significa que queremos despausar
		_resume_game()
	else:
		# Se o menu está escondido, queremos pausar
		_pause_game()

func _pause_game():
	get_tree().paused = true # Pausa o motor do jogo
	show() # Mostra o CanvasLayer do menu
	$MarginContainer/VBoxContainer/Resume.grab_focus()

func _resume_game():
	get_tree().paused = false # Despausa o motor do jogo
	hide() # Esconde o CanvasLayer do menu

# --- SINAIS DOS BOTÕES ---
# Lembre-se de conectar estes sinais no Editor do Godot!


func _on_resume_pressed() -> void:
	# Clicou em continuar, fecha o menu
	_resume_game()


func _on_exit_game_pressed() -> void:
		# Clicou em voltar ao menu.
	# O SceneManager alterado acima vai cuidar do unpause automaticamente.
	SceneManager.change_scene(SceneManager.Scenes.MENU)
