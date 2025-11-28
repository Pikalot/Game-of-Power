extends CanvasLayer
signal closed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	emit_signal("closed")
	self.hide()

func _on_visibility_changed() -> void:
	if (self.visible == true):
		get_tree().paused = true
	elif (self.visible == false):
		get_tree().paused = false

func _on_main_menu_button_pressed() -> void:
	var Scene = load("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(Scene)
