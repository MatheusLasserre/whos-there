extends CanvasLayer

@onready var text: RichTextLabel = $RichTextLabel
@onready var game: Game = $".."

@onready var larry: Larry = $"../Larry"

@export var time: float = 300.0;

@export var sanity_rate: float = 0.005
@export var health_rate: float = 2.0

func _ready() -> void:
	pass

func set_timer(value: float) -> void:
	time = value

func _process(delta: float) -> void:
	if time > 0:
		time -= delta
		text.text = "[center][font_size=32][color=black]%d:%02d[/color][/font_size][/center]" % [int(time/60), int(time)%60]
		if _is_door_open():
			_increment_sanity(delta)
		else:
			_decrement_health(delta)
	else:
		SignalBus.emit_signal("timer_end")

func _is_door_open()->bool:
	return game.is_door_open

func _increment_sanity(value:float)->void:
	var san = larry.get_sanity()
	var scale_factor = (100.0 - san) * sanity_rate
	if scale_factor < 0.01:
		scale_factor = 0.01
	larry.set_sanity(san + scale_factor * value)

func _decrement_health(value:float)->void:
	var health = larry.get_health()
	larry.set_health(health - health_rate*value)
