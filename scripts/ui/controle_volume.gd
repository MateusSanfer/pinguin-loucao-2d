extends CanvasLayer

const SAVE_PATH = "user://settings.cfg"

@onready var slider_sfx: HSlider = $Control/LabelSFX/SliderSFX
@onready var slider_music: HSlider = $Control/LabelMusic/SliderMusic

var music_bus_index: int
var sfx_bus_index: int

func _ready() -> void:
	# Pega o índice dos Audio Bus pelo nome
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	
	# Carrega os volumes salvos e atualiza os sliders
	_load_settings()

func _on_slider_music_value_changed(value: float) -> void:
	# Altera o volume do Bus global de Música
	AudioServer.set_bus_volume_db(music_bus_index, value)
	_save_settings()

func _on_slider_sfx_value_changed(value: float) -> void:
	# Altera o volume do Bus global de SFX
	AudioServer.set_bus_volume_db(sfx_bus_index, value)
	_save_settings()

func _on_voltar_pressed() -> void:
	# Retorna para a cena de onde veio (Menu ou Pause)
	SceneManager.go_back()

func _save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", slider_music.value)
	config.set_value("audio", "sfx_volume", slider_sfx.value)
	config.save(SAVE_PATH)

func _load_settings():
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	
	if err == OK:
		var music_vol = config.get_value("audio", "music_volume", 0.0)
		var sfx_vol = config.get_value("audio", "sfx_volume", 0.0)
		
		# Atualiza os sliders (que disparam os sinais automaticamente)
		slider_music.value = music_vol
		slider_sfx.value = sfx_vol
	else:
		# Primeira vez: usa os valores padrão dos sliders
		AudioServer.set_bus_volume_db(music_bus_index, slider_music.value)
		AudioServer.set_bus_volume_db(sfx_bus_index, slider_sfx.value)
