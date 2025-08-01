extends Node2D

func _ready() -> void:
	set_sanity_meter(0)

func set_sanity_meter(value:float):
	$UI/SanityMeter.value = value;
