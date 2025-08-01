extends CanvasLayer

@onready var text: RichTextLabel = $RichTextLabel

var time: float;

func _ready() -> void:
	pass

func set_timer(value: float) -> void:
	time = value

func _process(delta: float) -> void:
	if time > 0:
		time -= delta
	
	text.text = "[center][color=black]%d:%02d[/color][/center]" % [int(time/60), int(time)%60]
