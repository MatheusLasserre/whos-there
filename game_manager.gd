extends Node

enum GameState {
	MAIN_MENU,
	INGAME,
	ENDGAME,
}

var _states_scenes: Dictionary[GameState, String] = {
	GameState.MAIN_MENU: "res://scenes/menu/menu.tscn",
	GameState.INGAME: "res://scenes/game/game.tscn",
	GameState.ENDGAME: "res://scenes/endgame/endgame.tscn",
}
var current_game_state: GameState = GameState.MAIN_MENU
var _current_scene_root: Node
var game_status: String = 'win'

func _ready() -> void:
	SignalBus.timer_end.connect(_win)
	SignalBus.health_depleted.connect(_lose)
	SignalBus.sanity_maxed.connect(_lose)

func _win()->void:
	if current_game_state != GameState.ENDGAME:
		game_status = 'win'
		set_state(GameState.ENDGAME)
		print("You Win!")

func _lose()->void:
	if current_game_state != GameState.ENDGAME:
		game_status = 'lose'
		set_state(GameState.ENDGAME)
		print("You Lost")

func set_state(state: GameState) -> void:
	if _current_scene_root != null:
		_current_scene_root.queue_free()
	
	var scene: PackedScene = load(_states_scenes[state])
	_current_scene_root = scene.instantiate()
	current_game_state = state
	add_child(_current_scene_root)
	
	if state == GameState.INGAME:
		SignalBus.emit_signal("display_dialog", "yap_test")
