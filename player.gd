extends Area2D
signal hit

@export var speed = 500 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var touchPos
var touching

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func start(pos):
	position = pos
	show()
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
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO + Vector2(100, 0), screen_size - Vector2(100, 0))


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		touching = true;
		touchPos = event.position

	
	
