extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	self.hide()

func _on_visibility_changed() -> void:
	if (self.visible == true):
		get_tree().paused = true
	elif (self.visible == false):
		get_tree().paused = false
