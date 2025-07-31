extends Node2D

@onready var play: Button = $UI/Buttons/Play
@onready var settings: Button = $UI/Buttons/Settings
@onready var quit: Button = $UI/Buttons/Quit
@onready var settings_menu: Control = $UI/Settings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play.pressed.connect(handle_play_pressed)
	settings.pressed.connect(handle_settings_pressed)
	quit.pressed.connect(handle_quit_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_play_pressed() -> void:
	pass

func handle_settings_pressed() -> void:
	settings_menu.visible = true

func handle_quit_pressed() -> void:
	get_tree().quit()
