extends Area2D

@export var speed: float = 300.0

var player: Node = null

func _process(delta: float) -> void:
	position.y -= speed * delta  # Move upward

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_hit"):
		body.take_hit(player.power)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	queue_free()

func _ready() -> void:
	$AnimatedSprite2D.play("default")
