extends CanvasLayer

@onready var text: RichTextLabel = $RichTextLabel
@onready var game: Game = $".."

var time: float = 5 * 60;

func _ready() -> void:
	pass

func set_timer(value: float) -> void:
	time = value

func _process(delta: float) -> void:
	if time > 0:
		time -= delta
		text.text = "[center][font_size=32][color=black]%d:%02d[/color][/font_size][/center]" % [int(time/60), int(time)%60]
	else:
		SignalBus.emit_signal("timer_end")

func _is_door_open()->bool:
	return game.is_door_open
