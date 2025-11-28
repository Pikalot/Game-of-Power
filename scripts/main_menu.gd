extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_settings_button_pressed() -> void:
	$Main_Menu_Settings.show()

func _on_play_button_pressed() -> void:
	var Scene = load("res://scenes/level_select.tscn")
	get_tree().change_scene_to_packed(Scene)


func _on_main_menu_settings_closed() -> void:
	$Main_Menu_Settings.hide()
