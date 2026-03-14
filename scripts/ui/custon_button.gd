extends Button
class_name CustonButton

@onready var click: AudioStreamPlayer = $Click
@onready var on_hover: AudioStreamPlayer = $OnHover

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	click.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	on_hover.play()
