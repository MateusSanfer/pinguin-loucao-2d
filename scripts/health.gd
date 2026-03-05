extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.player_stats_changed.connect(_on_player_player_stats_changed)

func _on_player_player_stats_changed(player) -> void:
	$bar.size.x = 72 * player.health / player.max_health
