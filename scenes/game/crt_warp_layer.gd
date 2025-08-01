class_name CRTWarpLayer
extends CanvasLayer

@onready var crt_warp: ColorRect = $CRTWarp

func set_wiggle_strength(value: float) -> void:
	crt_warp.material.set_shader_parameter("wiggleMult", value)
