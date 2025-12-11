extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()
	if(OS.get_name() != "Android" || OS.get_name() != "iOS"):
		$MoveTutorial.text = "Move by dragging your mouse"
	$MoveTutorial.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HUD.update_power($Player.power)
	
func new_game():
	$StartTimer.start()
	$Player.start($StartPosition.position)
	$Player.power = 1
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("power ups", "queue_free")
	$BGM.play()

# Terminate game	
func game_over():
	$HUD.show_game_over()
	$MobTimer.stop()
	$BGM.stop()
	$GameOver.play()
	stop_timer()
	hide_tutorial()

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	# set where "half the screen" is
	mob.screen_half_y = get_viewport().get_visible_rect().size.y / 2
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
func _on_hud_restart_game() -> void:
	_ready()

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$MoveTutorial.hide()
	$FireTutorial.show()
	$ShowPowerTutorial1.start()

func _on_show_power_tutorial_1_timeout() -> void:
	$FireTutorial.hide()
	$PowerTutorial1.show()
	$ShowPowerTutorial2.start()

func _on_show_power_tutorial_2_timeout() -> void:
	$PowerTutorial1.hide()
	$PowerTutorial2.show()
	$ShowPowerTutorial3.start()

func _on_show_power_tutorial_3_timeout() -> void:
	$PowerTutorial2.hide()
	$PowerTutorial3.show()
	$ShowPowerUpTutorial.start()

func _on_show_poer_up_tutorial_timeout() -> void:
	$PowerTutorial3.hide()
	$PowerUpTutorial.show()
	$TutorialCompleteTimer.start()

func _on_tutorial_complete_timer_timeout() -> void:
	$PowerUpTutorial.hide()
	$TutorialComplete.show()
	$EndLevelTimer.start()

func _on_end_level_timer_timeout() -> void:
	var Scene = load("res://scenes/level_select.tscn")
	get_tree().change_scene_to_packed(Scene)
	
func stop_timer() -> void:
	$MobTimer.stop()
	$StartTimer.stop()
	$ShowPowerTutorial1.stop()
	$ShowPowerTutorial2.stop()
	$ShowPowerTutorial3.stop()
	$ShowPowerUpTutorial.stop()
	$TutorialCompleteTimer.stop()
	$EndLevelTimer.stop()

func hide_tutorial() -> void:
	$MoveTutorial.hide()
	$FireTutorial.hide()
	$PowerTutorial1.hide()
	$PowerTutorial3.hide()
	$PowerUpTutorial.hide()
	$TutorialComplete.hide()
