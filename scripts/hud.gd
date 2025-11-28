extends CanvasLayer
signal restart_game
var settings_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RestartButton.hide()
	$Message.hide()
	settings_scene = preload("res://scenes/settings.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func show_message(text):
	$Message.text = text
	$Message.show()
	
func show_game_over():
	show_message("Game Over")
	$RestartButton.show()
	
func update_power(power):
	$PowerNumberLabel.text = str(power)
	$PowerNumberLabel.show()

func _on_restart_pressed():
	$RestartButton.hide()
	$Message.hide()
	restart_game.emit()

func _on_settings_button_pressed():
	$SettingsButton.hide()
	$Settings.show()

func _on_settings_closed():
	$SettingsButton.show()
