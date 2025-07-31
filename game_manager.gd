extends Node

enum GameState {
	MAIN_MENU,
}

var _states_scenes: Dictionary[GameState, String] = {
	GameState.MAIN_MENU: "res://scenes/menu/menu.tscn",
}

var _current_scene_root: Node

func set_state(state: GameState) -> void:
	if _current_scene_root != null:
		_current_scene_root.queue_free()
	
	var scene: PackedScene = load(_states_scenes[state])
	_current_scene_root = scene.instantiate()
	add_child(_current_scene_root)
