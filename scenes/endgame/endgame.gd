extends Node2D
@export var win_container: AspectRatioContainer
@export var lose_container: AspectRatioContainer
@export var label_text1: Label
@export var label_text2: Label
@export var label_text3: Label
@export var label_text4: Label
@onready var main_menu: Button = $CanvasLayer/MainMenu

const win_text := "at the face of adversity, and possibly just the thought of entertaining conversation with your odd neighbor on a saturday morning, you slam the door shut, getting back into watching your show forever and ever, under the bliss of not knowing what would've been a nice conversation with Larry"
const lose_text := "And so, Larry kept talking and talking... Talking with you, you and himself for so long, that he talked until the apocalypse happened. You both stand now at the end of times where nothing is nowhere, and everything, is Larry."

const win_text_arr: Array[String] = [
	"At the face of adversity, and possibly just the thought of entertaining conversation with your odd neighbor on a Saturday morning,",
	"you slam the door shut.",
	"Getting back into watching your show forever and ever,",
	"under the bliss of not knowing what would've been a nice conversation with Larry.",
]

const lose_text_arr: Array[String] = [
	"And so, Larry kept talking and talking...",
	"Talking with you, you and himself for so long,",
	"that he talked until the apocalypse happened.",
	"You both stand now at the end of times, where nothing is nowhere, and everything is Larry.",
]

var text_to_display: Array[String]
var typing_speed: float = 0.06
var typing_counter: float = 0
var current_text_length = 0
var visible_characters = 0
var label_arr: Array[Label]
var cur_text_idx: int = 0
func _ready() -> void:
	main_menu.pressed.connect(handle_main_menu)
	populate_label_array()
	if GameManager.game_status == 'win':
		win_container.visible = true
		text_to_display = win_text_arr
	else:
		lose_container.visible = true
		text_to_display = lose_text_arr
	current_text_length = text_to_display[cur_text_idx].length()

func populate_label_array() -> void:
	label_arr = [label_text1, label_text2, label_text3, label_text4]

func _process(delta: float) -> void:
	process_typing_text(delta)

func process_typing_text(delta: float) -> void:
	if cur_text_idx == label_arr.size():
		main_menu.visible = true
		return
	typing_counter += delta
	if typing_counter >= typing_speed:
		typing_counter -= typing_speed
		visible_characters += 1
		update_current_text()
	check_and_update_selected_text()

func update_current_text() -> void:
	label_arr[cur_text_idx].text = text_to_display[cur_text_idx].substr(0, visible_characters)

func check_and_update_selected_text() -> void:
	if visible_characters == current_text_length:
		cur_text_idx += 1
		if cur_text_idx == label_arr.size():
			return
		current_text_length = text_to_display[cur_text_idx].length()
		visible_characters = 0
		label_arr[cur_text_idx].visible = true
	
func handle_main_menu() -> void:
	GameManager.set_state(GameManager.GameState.MAIN_MENU)
