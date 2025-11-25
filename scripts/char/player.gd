
extends Area2D
signal dead

@export var bullet_scene: PackedScene
@export var power = 1
@export var speed = 500 # How fast the player will move (pixels/sec).

var screen_size # Size of the game window.
var touchPos
var touching
var mob: Node = null
var invincible: bool = false
var invincible_duration: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func start(pos):
	touching = false;
	position = pos
	show()
	$ShootTimer.start()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if(touching):
		if (touchPos.x < position.x - 50):
			velocity.x -= 1
		if (touchPos.x > position.x + 50):
			velocity.x += 1
	if(!touching):
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
			velocity.x -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	$AnimatedSprite2D.play()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO + Vector2(150, 0), screen_size - Vector2(150, 0))
	
	# Show player power
	$PowerLabel.text = "x" + str(power)

func _on_body_entered(body: Node2D) -> void:
	if invincible or "power" not in body:
		return
	
	# Boss special attack
	if body.name == "boss":
		body.attack()

		# DELAY DAMAGE UNTIL THE HIT FRAME
		await get_tree().create_timer(1.0).timeout  # 7 frames @ 7 FPS

		# Check if player is still overlapping AND attack is still happening
		if body.is_attacking and body in get_overlapping_bodies():
			take_hit(body.power)
		else:
			body.stop_attack()
		
		if power <= 0:
			body.stop_attack()	

		return

	take_hit(body.power)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		touching = true;
		touchPos = event.position

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.player = self
	get_parent().add_child(bullet)
	
func stop_shooting() -> void:
	$ShootTimer.stop()

func _on_shoot_timer_timeout() -> void:
	shoot()
	
func take_hit(damage: int) -> void:
	if invincible:
		return  # ignore damage during i-frames

	$HurtSound.play()
	power -= damage
	if power <= 0:
		die()
	else:
		start_invincibility()
		
func die() -> void:
	stop_shooting()
	hide() # Player disappears after being hit.
	dead.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start_invincibility() -> void:
	invincible = true
	
	# Flash effect
	var flash_tween = create_tween()
	flash_tween.tween_property($AnimatedSprite2D, "modulate:a", 0.2, 0.1)
	flash_tween.tween_property($AnimatedSprite2D, "modulate:a", 1.0, 0.1)
	flash_tween.set_loops(5)  # flashing 5 times

	# Timer to end invincibility
	await get_tree().create_timer(invincible_duration).timeout
	invincible = false
	$AnimatedSprite2D.modulate = Color(1,1,1,1)  # reset fully visible
	
func set_power(newPower: int) -> void:
	power = newPower
