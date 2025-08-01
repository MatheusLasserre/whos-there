extends CanvasLayer

@onready var texture: TextureRect = $TextureRect
@onready var crt_warp: CRTWarpLayer = $"../CRTWarp Layer"

var sprites = {
	20: [1,2,3,4,5,6],
	40: [7,8,9,10,11],
	60: [12,13,14,15,16,17,18],
	80: [19,20,21,22,23,24],
	100: [25,26,27,28,29,30,31,32,33,34]
}
var _sprite_index: int = 0

var _sanity: float = 0.0;

func _ready() -> void:
	SignalBus.larry_animate.connect(animate_larry)
	_set_sanity_meter()

func get_sanity()->float:
	return _sanity

func set_sanity(value:float)->void:
	_sanity = value
	_set_sanity_meter()

func _set_sanity_meter():
	$"../Sanity/SanityMeter".value = 0.0 - _sanity

func _set_crt_warp():
	if _sanity <= 20:
		crt_warp.set_wiggle_strength(0)
	elif _sanity <= 40:
		crt_warp.set_wiggle_strength(0.005)
	elif _sanity <= 60:
		crt_warp.set_wiggle_strength(0.01)
	elif _sanity <= 80:
		crt_warp.set_wiggle_strength(0.025)
	else:
		crt_warp.set_wiggle_strength(0.5)

func animate_larry() -> void:
	if _sanity <= 20:
		if _sprite_index >= len(sprites[20]):
			_sprite_index = 0
		texture.texture = load_larry(sprites[20][_sprite_index])
		_sprite_index += 1
		return
	
	if _sanity <= 40:
		if _sprite_index >= len(sprites[40]):
			_sprite_index = 0
		texture.texture = load_larry(sprites[40][_sprite_index])
		_sprite_index += 1
		return
	
	if _sanity <= 60:
		if _sprite_index >= len(sprites[60]):
			_sprite_index = 0
		texture.texture = load_larry(sprites[60][_sprite_index])
		_sprite_index += 1
		return
	
	if _sanity <= 80:
		if _sprite_index >= len(sprites[80]):
			_sprite_index = 0
		texture.texture = load_larry(sprites[80][_sprite_index])
		_sprite_index += 1
		return
	
	if _sanity <= 100:
		if _sprite_index >= len(sprites[100]):
			_sprite_index = 0
		texture.texture = load_larry(sprites[100][_sprite_index])
		_sprite_index += 1
		return

func load_larry(sprite_number):
	var sprite = "res://LARRY/LARRY1.png".replace("1", str(sprite_number))
	return load(sprite)
