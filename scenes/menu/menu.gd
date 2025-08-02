extends Node2D

@export var play: Button
@export var settings: Button
@export var quit: Button
@export var settings_menu: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play.pressed.connect(handle_play_pressed)
	settings.pressed.connect(handle_settings_pressed)
	quit.pressed.connect(handle_quit_pressed)

func handle_play_pressed() -> void:
	GameManager.set_state(GameManager.GameState.INGAME)

func handle_settings_pressed() -> void:
	settings_menu.visible = true
	self.visible = false

func handle_quit_pressed() -> void:
	get_tree().quit()
