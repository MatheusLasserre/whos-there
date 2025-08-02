extends Control

@onready var back: Button = $Panel/back


func _ready() -> void:
	back.pressed.connect(handle_back)

func handle_back() -> void:
	self.visible = false
