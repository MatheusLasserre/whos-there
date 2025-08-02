extends CanvasLayer

@onready var sanity_meter: TextureProgressBar = $"../Sanity/SanityMeter"

@onready var texture: TextureRect = $Larry
@onready var crt_warp: CRTWarpLayer = $"../CRTWarp Layer"
@onready var corruption: TextureRect = $Corruption

var sprites = range(1, 35)
var _sprite_index: int = 0

var _sanity: float = 0.0;

func _ready() -> void:
	SignalBus.larry_animate.connect(animate_larry)
	set_sanity(20.0)

func get_sanity()->float:
	return _sanity

func set_sanity(value:float)->void:
	_sanity = value
	_set_sanity_meter()
	_set_crt_warp()
	_set_corruption_sprite()

func _set_sanity_meter():
	sanity_meter.value = _sanity
	if _sanity < 20:
		sanity_meter.material.set_shader_parameter("amount", 0.0)
	elif _sanity < 40:
		sanity_meter.material.set_shader_parameter("amount", 1.0)
	elif _sanity < 60:
		sanity_meter.material.set_shader_parameter("amount", 5.0)
	elif _sanity < 80:
		sanity_meter.material.set_shader_parameter("amount", 10.0)
	else:
		sanity_meter.material.set_shader_parameter("amount", 25.0)

func _set_crt_warp():
	if _sanity < 20:
		crt_warp.set_wiggle_strength(0)
	elif _sanity < 40:
		crt_warp.set_wiggle_strength(0.005)
	elif _sanity < 60:
		crt_warp.set_wiggle_strength(0.01)
	elif _sanity < 80:
		crt_warp.set_wiggle_strength(0.025)
	else:
		crt_warp.set_wiggle_strength(0.5)

func _set_corruption_sprite():
	if _sanity < 20:
		corruption.visible = false
	elif _sanity < 40:
		corruption.visible = true
		corruption.texture = load("res://CORRUPTION/corruption_1.png")
	elif _sanity < 60:
		corruption.visible = true
		corruption.texture = load("res://CORRUPTION/corruption_2.png")
	elif _sanity < 80:
		corruption.visible = true
		corruption.texture = load("res://CORRUPTION/corruption_3.png")
	else:
		corruption.visible = true
		corruption.texture = load("res://CORRUPTION/corruption_4.png")

func animate_larry() -> void:
	if _sprite_index >= len(sprites):
		_sprite_index = 0
	texture.texture = load_larry(sprites[_sprite_index])
	_sprite_index += 1
	
	_set_corruption_sprite()

func load_larry(sprite_number):
	var sprite = "res://LARRY/LARRY1.png".replace("1", str(sprite_number))
	return load(sprite)


func _on_sanity_meter_value_changed(value: float) -> void:
	set_sanity(value)
