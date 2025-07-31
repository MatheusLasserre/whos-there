extends VBoxContainer

@onready var play: Button = $Play
@onready var settings: Button = $Settings
@onready var quit: Button = $Quit
@onready var settings_menu: Control = $"../Settings"

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
	self.visible = false

func handle_quit_pressed() -> void:
	get_tree().quit()
