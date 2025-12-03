extends "res://scripts/utils/animation.gd"

@export var power = 20
@export var speed_x = 150      	# sideways speed
@export var speed_y = 120 			# vertical downward movement
@export var acceleration = 25
@export var max_speed = 450

signal died

var dir_x = 1           				# 1 = right, -1 = left
var dir_y = 1
var is_attacking = false
var is_dead = false

var screen_half_y = 0  # will be set from Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_animation("walk")
	dir_x = -1 if randf() < 0.5 else 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PowerLabel.text = "x" + str(power)


func _integrate_forces(state):
	var left_limit = 160
	var right_limit = get_viewport_rect().size.x - 160

	# move diagonally down
	linear_velocity = Vector2(dir_x * speed_x, dir_y * speed_y)

	# zig-zag logic: bounce when touching wall
	if position.x <= left_limit:
		dir_x = 1      # turn right
	elif position.x >= right_limit:
		dir_x = -1     # turn left
	
	if position.y <= screen_half_y:
		dir_y = 1
	elif position.y >= get_viewport_rect().size.y:
		dir_y = -1

func die() -> void:
	if is_dead:
		return

	is_dead = true
	emit_signal("died")
	
	speed_x = 0
	speed_y = 0

	# Play death sound
	var death_sound = $DeadSound.duplicate()
	get_parent().add_child(death_sound)
	death_sound.play()
	
	# Play death animation
	play_animation("die")
	# Wait for animation to finish
	await $AnimatedSprite2D.animation_finished
	queue_free()

func take_hit(damage: int) -> void:
	if is_dead:
		return

	power -= damage
	if power <= 0:
		die()


func attack() -> void:
	if is_dead:
		return
	
	is_attacking = true
	play_animation("attack")

func stop_attack() -> void:
	if is_dead:
		return

	is_attacking = false
	play_animation("walk")
