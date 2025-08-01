extends Node2D

@export var open_door_button: Button
@export var door_pivot: Node3D
var door_open_degrees: float = -130
var door_closed_degrees: float = 0
var door_lerp_mod: float = 5
var is_door_open: bool = false

func _ready() -> void:
	open_door_button.pressed.connect(toggle_door)

func _physics_process(delta: float) -> void:
	update_door(delta)

func _process(delta: float) -> void:
	pass

func toggle_door() -> void:
	is_door_open = !is_door_open
	open_door_button.text = "Close Door" if is_door_open else "Open Door"

func update_door(delta: float) -> void:
	var target_rotation = door_open_degrees if is_door_open else door_closed_degrees
	door_pivot.rotation_degrees.z = lerp(
		door_pivot.rotation_degrees.z,
		target_rotation,
		door_lerp_mod * delta
	)
