class_name DialoguePlayer
extends Node

@export_file("*.json") var scene_text_file

var scene_text = {}
var selected_text = []
<<<<<<< Updated upstream
var in_progress = false
var is_typing = false

@export var typing_speed = 0.25
var typing_counter = 0

=======
var dialog_options = []
var current: String = ""
var next: Dictionary = {}
var in_progress = false
var is_typing = false

var _door_open = false

var _first : bool = true

@export var typing_speed = 0.25
var typing_counter = 0

@export var start_keys : Array[String] = []

@export var end_padding: int = 5

>>>>>>> Stashed changes
@onready var background = $Background
@onready var text_label = $TextLabel
@onready var blur = $Blur

func _ready() -> void:
	#background.visible = false
	scene_text = load_scene_text()
	SignalBus.display_dialog.connect(on_display_dialog)

func _process(delta) -> void:
	if is_typing:
		typing_counter += delta
		if typing_counter >= typing_speed:
			typing_counter = 0
			type_text()

func type_text() -> void:
	var count = text_label.get_total_character_count()
	if text_label.visible_characters < count:
		text_label.visible_characters += 1
	else:
		is_typing = false

func finish_typing() -> void:
	text_label.visible_characters = -1
	is_typing = false

func load_scene_text():
	var json_as_text = FileAccess.get_file_as_string(scene_text_file)
	return JSON.parse_string(json_as_text)

<<<<<<< Updated upstream
=======
func _on_door_toggled(toggle:bool)->void:
	_door_open = toggle
	if not _door_open:
		end()
	else:
		if _first:
			on_display_dialog(start_keys[0])
			_first = false
		else:
			on_display_dialog(start_keys[randi_range(1, len(start_keys)-1)])

>>>>>>> Stashed changes
func on_display_dialog(text_key):
	if in_progress and not is_typing:
		next_line()
	elif not is_typing:
<<<<<<< Updated upstream
		get_tree().paused = true
		#background.visible = true
=======
		#get_tree().paused = true
		current = text_key
		options.visible = false
		background.visible = true
>>>>>>> Stashed changes
		in_progress = true
		selected_text = process_text_data(scene_text[text_key])
		next_line()
	else:
		finish_typing()

func process_text_data(data:Dictionary) -> Array:
	var color = null
	var font_size = null
	var alignment = null
	if data.has("color"):
		color = data["color"]
	else:
		color = "red"
	
	if data.has("font_size"):
		font_size = data["font_size"]
	else:
		font_size = 36
		
	if data.has("alignment"):
		alignment = data["alignment"]
<<<<<<< Updated upstream
=======
	else:
		alignment = "center"
	
	if data.has("dialog_options"):
		dialog_options = data["dialog_options"]
	elif data.has("next"):
		next = data["next"]
>>>>>>> Stashed changes

	var texts = data["text"].duplicate()
	
	for i in range(len(texts)):
		if color != null:
			texts[i] = ("[color=%s]" % [color]) + texts[i] + "[/color]"
		if font_size != null:
			texts[i] = ("[font_size=%d]" % [font_size]) + texts[i] + "[/font_size]"
		if alignment != null:
			texts[i] = ("[%s]" % [alignment]) + texts[i] + ("[/%s]" % [alignment])
	
	print(texts)
	
	return texts

func show_text():
	text_label.text = selected_text.pop_front()
	is_typing = true
	text_label.visible_characters = 0;

func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()

func finish():
	text_label.text = ""
	#background.visible = false
	in_progress = false
	get_tree().paused = false

func set_blur(value:float):
	blur.material.set_shader_parameter("blur_amount", value);


func _on_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			on_display_dialog("yap_test")


func _on_text_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
<<<<<<< Updated upstream
			on_display_dialog("yap_test")
=======
			choose_option(a)

func _on_option_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			choose_option(b)

func _on_option_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			choose_option(c)

func choose_option(number:int) -> void:
	if not options.is_visible_in_tree() or len(dialog_options) < 3:
		return
	
	prompt_select.play()
	
	var key = dialog_options[number-1]["key"]
	larry.increase_sanity(float(dialog_options[number-1]["sanity"]))
	var san = larry.get_sanity()
	if san >= 80:
		on_display_dialog(key["Insane"])
	elif san >= 40:
		on_display_dialog(key["Half-Sane"])
	else:
		on_display_dialog(key["Sane"])
>>>>>>> Stashed changes
