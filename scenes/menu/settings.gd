extends Control

@onready var back: Button = $Panel/back
@export var buttons_container: VBoxContainer


func _ready() -> void:
	back.pressed.connect(handle_back)

func handle_back() -> void:
	self.visible = false
	buttons_container.visible = true
