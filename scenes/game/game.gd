class_name Game
extends Node2D

@export var open_door_button: Button
@export var door_pivot: Node3D
var door_open_degrees: float = -130
var door_closed_degrees: float = 0
var door_lerp_mod: float = 5
var is_door_open: bool = false

@onready var dialogue: DialoguePlayer = $DialoguePlayer

@onready var door_close: AudioStreamPlayer = $Door/DoorClose
@onready var door_open: AudioStreamPlayer = $Door/DoorOpen

func _ready() -> void:
	open_door_button.pressed.connect(toggle_door)

func _physics_process(delta: float) -> void:
	update_door(delta)

func _process(_delta: float) -> void:
	if dialogue.current.contains("_option_") or dialogue.current.contains("open_"):
		open_door_button.disabled = true
	else:
		open_door_button.disabled = false

func toggle_door() -> void:
	is_door_open = !is_door_open
	SignalBus.emit_signal("toggle_door", is_door_open)
	
	if is_door_open:
		door_open.play()
	else:
		door_close.play()

func update_door(delta: float) -> void:
	var target_rotation = door_open_degrees if is_door_open else door_closed_degrees
	door_pivot.rotation_degrees.z = lerp(
		door_pivot.rotation_degrees.z,
		target_rotation,
		door_lerp_mod * delta
	)
