extends Control


@export var audio_name: String
@export var bus_channel: String
var bus_idx: int
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var h_slider: HSlider = $MarginContainer/HBoxContainer/HSlider

func _ready() -> void:
	bus_idx = AudioServer.get_bus_index(bus_channel)
	label.text = audio_name
	h_slider.value_changed.connect(handle_volume_change)

func handle_volume_change(value: float) -> void:
	var audio_value := linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_idx, audio_value)
