extends Area2D

@export var speed: float = 500.0

var player: Node = null

func _process(delta: float) -> void:
	position.y -= speed * delta  # Move upward

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_hit"):
		body.take_hit(player.power)
	
	var hit = $HitSound.duplicate()
	get_parent().add_child(hit)
	hit.play()
	
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	queue_free()

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$Shoot.play()
