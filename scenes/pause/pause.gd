extends Node2D

@onready var resume: Button = $UI/resume
@onready var settings: Button = $UI/Settings2
@onready var quit: Button = $UI/Quit
@onready var settings_menu: Control = $UI/Settings
@onready var ui: CanvasLayer = $UI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume.pressed.connect(handle_resume_pressed)
	settings.pressed.connect(handle_settings_pressed)
	quit.pressed.connect(handle_quit_pressed)

func handle_settings_pressed() -> void:
	settings_menu.visible = true
	self.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		handle_resume_pressed()

func handle_quit_pressed() -> void:
	get_tree().quit()

func handle_resume_pressed() -> void:
	var target := !get_tree().paused
	get_tree().paused = target
	ui.visible = target
	self.visible = target
