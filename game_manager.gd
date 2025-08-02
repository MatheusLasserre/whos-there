extends Node

enum GameState {
	MAIN_MENU,
	INGAME,
}

var _states_scenes: Dictionary[GameState, String] = {
	GameState.MAIN_MENU: "res://scenes/menu/menu.tscn",
	GameState.INGAME: "res://scenes/game/game.tscn",
}

var _current_scene_root: Node

func _ready() -> void:
	SignalBus.timer_end.connect(_win)
	SignalBus.health_depleted.connect(_lose)
	SignalBus.sanity_maxed.connect(_lose)

func _win()->void:
	print("You Win!")

func _lose()->void:
	print("You Lost")

func set_state(state: GameState) -> void:
	if _current_scene_root != null:
		_current_scene_root.queue_free()
	
	var scene: PackedScene = load(_states_scenes[state])
	_current_scene_root = scene.instantiate()
	add_child(_current_scene_root)
	
	if state == GameState.INGAME:
		SignalBus.emit_signal("display_dialog", "yap_test")
