extends CanvasLayer

@export var timer_highlight: Panel
@export var health_highlight: Panel
@export var insanity_highlight: Panel
@export var open_door_highlight: Panel
@export var next_button: Button
@export var text_label: Label

const sequence := ["health", "insanity", "door", "timer", "extra"]

const text_dict: Dictionary[String, String] = {
	"health": "That's your health bar. Staying shut at home is not good for your health.",
	"insanity": "That's your insanity meter. Talking with others can help... Sometimes.",
	"door": "Here you can click to open and close the door. You can always open it. For closing it... Well, you have good manners, so sometimes you have to wait for others to finish talking.",
	"timer": "Here it's your timer. Try to be healthy and sane till it hit's 0.",
	"extra": "Oh, I think someone is knocking at your door. I think you should open the door and choose a topic to talk... carefully."
}
var panel_dict: Dictionary[String, Panel]
var cur_index := 0
var max_index := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	next_button.pressed.connect(handle_next)
	max_index = sequence.size() - 1
	populate_panel_dict()
	set_current_step()


func handle_next() -> void:
	if cur_index == max_index:
		self.visible = false
		get_tree().paused = false
		return
	remove_current_highlight()
	cur_index += 1
	set_current_step()

func set_current_step() -> void:
	text_label.text = text_dict[sequence[cur_index]]
	panel_dict[sequence[cur_index]].visible = true
	if cur_index == max_index:
		next_button.text = "Ok. I'll be nice."

func remove_current_highlight() -> void:
	panel_dict[sequence[cur_index]].visible = false

func populate_panel_dict() -> void:
	panel_dict = {
	"health": health_highlight,
	"insanity": insanity_highlight,
	"door": open_door_highlight,
	"timer": timer_highlight,
	"extra": timer_highlight
	}
