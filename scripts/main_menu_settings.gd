extends CanvasLayer
signal closed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	get_tree().paused = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	emit_signal("closed")
	self.hide()
