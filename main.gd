extends Node

@export var mob_scene: PackedScene
@export var power = 1
@export var speed = 75

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func new_game():
	$Player.start($StartPosition.position)
	$StartTimer.start()

# Terminate game	
func game_over():
	$MobTimer.stop()


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

	## Set the mob's direction perpendicular to the path direction.
	#var direction = mob_spawn_location.rotation + PI / 2

	# Choose the velocity for the mob.
	#var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	#var velocity = Vector2(0, 75)
	#mob.linear_velocity = velocity

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
