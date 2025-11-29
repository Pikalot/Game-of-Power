extends Node
@export var level_name: String
var Scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Scene = load("res://scenes/" + level_name + ".tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(Scene)
	
