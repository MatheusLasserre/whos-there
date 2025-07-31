extends OptionButton

const window_options: Dictionary[String, DisplayServer.WindowMode] = {
	'Fullscreen': DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN,
	'Windowed': DisplayServer.WindowMode.WINDOW_MODE_WINDOWED,
}
var mode_idxs: Array[DisplayServer.WindowMode] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in window_options.keys():
		self.add_item(key)
		mode_idxs.append(window_options[key])
	item_selected.connect(_on_item_selected)
	var current_mode = DisplayServer.window_get_mode()
	var current_mode_idx = mode_idxs.find(current_mode)
	self.select(current_mode_idx)

func _on_item_selected(index: int) -> void:
	DisplayServer.window_set_mode(mode_idxs[index])
