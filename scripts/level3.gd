extends Node

@export var mob_scene: PackedScene
@export var boss_scene: PackedScene
@export var player_power = 1
@export var level_speed = 100
@export var enhanced_mob_power_factor = 1

var playerDead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HUD.update_power($Player.power)
	
	
func new_game():
	#Reset player
	$Player.start($StartPosition.position)
	$Player.power = player_power
	playerDead = false
	

	# Reset mob
	enhanced_mob_power_factor = 1
	level_speed = 100
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("power ups", "queue_free")
	get_tree().call_group("bosses", "queue_free")
	
	# stop & reset timers
	$MobTimer.stop()
	$Phase1Timer.stop()
	$BossTimer.stop()
	$CongratsTimer.stop()
	$EndLevelTimer.stop()
	
	$BGM.play()
	$StartTimer.start()

# Terminate game	
func game_over():
	$MobTimer.stop()
	$HUD.show_game_over()
	$BossTimer.stop()
	$BGM.stop()
	$GameOver.play()


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	mob.speed = level_speed
	mob.power *= enhanced_mob_power_factor
	mob.set_power_up_amt(randi_range(1, 2))
	# mob.set_power_up_amt(1)
	
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# set where "half the screen" is
	mob.screen_half_y = get_viewport().get_visible_rect().size.y / 2

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$Phase1Timer.start()

func _on_hud_restart_game() -> void:
	new_game()

func _on_phase_1_timer_timeout() -> void:
	enhanced_mob_power_factor = 6
	level_speed = 150
	$BossTimer.start()
	
func _on_congrats_timer_timeout() -> void:
	$Congrats.show()
	$EndLevelTimer.start()
	$Player.invincible = true

func _on_end_level_timer_timeout() -> void:
	var Scene = load("res://scenes/level_select.tscn")
	get_tree().change_scene_to_packed(Scene)


func _on_boss_timer_timeout() -> void:
	# Stop spawning mobs
	$MobTimer.stop()
	var boss = boss_scene.instantiate()

	# set where "half the screen" is for the boss
	boss.screen_half_y = get_viewport().get_visible_rect().size.y / 2

	# Spawn boss at the fixed marker
	boss.position = $BossSpawnLocation.position

	# Boss always moves downward (positive Y)
	var direction = Vector2(0, 1)

	# Add small randomness if you want
	direction = direction.rotated(randf_range(-0.2, 0.2))

	# Set downward velocity (because boss is RigidBody2D)
	boss.linear_velocity = direction * randf_range(100, 200)

	boss.died.connect(_on_boss_died)

	add_child(boss)

func _on_player_dead() -> void:
	playerDead = true

func _on_boss_died() -> void:
	if !playerDead:
		$CongratsTimer.start()
