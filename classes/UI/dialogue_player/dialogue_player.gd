class_name DialoguePlayer
extends Node

@export_file("*.json") var scene_text_file

var scene_text = {}
var selected_text = []
var dialog_options = []
var current: String = ""
var next: Dictionary = {}
var in_progress = false
var is_typing = false

var _door_open = false
var _first : bool = true

@export var typing_speed = 0.25
var typing_counter = 0

@export var start_keys: Array[String] = []

@export var end_padding: int = 5

@onready var background = $Background
@onready var text_label = $TextLabel
@onready var blur = $Blur

@onready var larry: Larry = $"../Larry"

@onready var options: VBoxContainer = $Options

@onready var option1: RichTextLabel = $Options/Option1/VBoxContainer/RichTextLabel
@onready var option2: RichTextLabel = $Options/Option2/VBoxContainer/RichTextLabel
@onready var option3: RichTextLabel = $Options/Option3/VBoxContainer/RichTextLabel

@onready var prompt_select: AudioStreamPlayer = $PromptSelect

func _ready() -> void:
	#background.visible = false
	scene_text = load_scene_text()
	SignalBus.display_dialog.connect(on_display_dialog)
	SignalBus.toggle_door.connect(_on_door_toggled)

func _process(delta) -> void:
	if is_typing:
		typing_counter += delta
		if typing_counter >= typing_speed:
			typing_counter -= typing_speed
			type_text()

func type_text() -> void:
	var count = text_label.get_total_character_count()
	if text_label.visible_characters < count + end_padding:
		text_label.visible_characters += 1
		SignalBus.emit_signal("larry_animate")
	else:
		is_typing = false
		next_line()

func finish_typing() -> void:
	text_label.visible_characters = -1
	is_typing = false

func load_scene_text():
	var json_as_text = FileAccess.get_file_as_string(scene_text_file)
	return JSON.parse_string(json_as_text)

func _on_door_toggled(toggle:bool)->void:
	_door_open = toggle
	if not _door_open:
		end()
	else:
		if _first:
			on_display_dialog(start_keys[0])
			_first = false
		else:
			on_display_dialog(start_keys[randi_range(1, len(start_keys))])

func on_display_dialog(text_key):
	if not _door_open:
		end()
		return
	
	if in_progress and not is_typing:
		next_line()
	elif not is_typing:
		#get_tree().paused = true
		current = text_key
		options.visible = false
		background.visible = true
		in_progress = true
		selected_text = process_text_data(scene_text[text_key])
		next_line()
	#else:
		#finish_typing()

func process_text_data(data:Dictionary) -> Array:
	var color = null
	var font_size = null
	var alignment = null
	next = {}
	dialog_options = []
	
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
	else:
		alignment = "center"
	
	if data.has("dialog_options"):
		dialog_options = data["dialog_options"]
	elif data.has("next"):
		next = data["next"]

	var texts = data["text"].duplicate()
	
	for i in range(len(texts)):
		if color != null:
			texts[i] = ("[color=%s]" % [color]) + texts[i] + "[/color]"
		if font_size != null:
			texts[i] = ("[font_size=%d]" % [font_size]) + texts[i] + "[/font_size]"
		if alignment != null:
			texts[i] = ("[%s]" % [alignment]) + texts[i] + ("[/%s]" % [alignment])
	
	#print(texts)
	
	return texts

func show_text():
	text_label.text = selected_text.pop_front()
	is_typing = true
	text_label.visible_characters = 0

func next_line():
	if not _door_open:
		return
	if selected_text.size() > 0:
		show_text()
	else:
		finish()

func end() -> void:
	in_progress = false
	text_label.text = ""
	background.visible = false

func finish() -> void:
	in_progress = false
	if len(dialog_options) > 0:
		show_options()
	elif len(next) != 0:
		var san = larry.get_sanity()
		if san >= 80:
			on_display_dialog(next["Insane"])
		elif san >= 40:
			on_display_dialog(next["Half-Sane"])
		else:
			on_display_dialog(next["Sane"])
		
		return
	
	text_label.text = ""
	background.visible = false
	#get_tree().paused = false

var a: int
var b: int
var c: int

func show_options() -> void:
	var opts = len(dialog_options)
	if len(dialog_options) < 3:
		return
	
	options.visible = true
	a = randi_range(0, opts - 1)
	
	b = randi_range(0, opts - 1)
	while a == b:
		b = randi_range(0, opts - 1)
	
	c = randi_range(0, opts - 1)
	while a == c or b == c:
		c = randi_range(0, opts - 1)
	
	option1.text = dialog_options[a]["option"]
	option2.text = dialog_options[b]["option"]
	option3.text = dialog_options[c]["option"]

func set_blur(value:float):
	blur.material.set_shader_parameter("blur_amount", value);

func _on_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pass
			#on_display_dialog(start_key)

func _on_option_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
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
