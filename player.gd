extends Area2D
signal hit

@export var speed = 400
var screen_size


func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	$AnimatedSprite2D.play()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	$AnimatedSprite2D.rotation = 0

	if velocity.length() == 0:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false


	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"

		$AnimatedSprite2D.flip_v = false

		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		$AnimatedSprite2D.flip_h = false

		if velocity.y > 0:
			#$AnimatedSprite2D.rotate(PI/2)
			$AnimatedSprite2D.rotation = PI/2
		else:
			#$AnimatedSprite2D.rotate(-PI/2)
			$AnimatedSprite2D.rotation = -PI/2


func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
