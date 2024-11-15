extends CPUParticles2D

func play():
	var screen = get_viewport_rect().size
	var tween = get_tree().create_tween()
	var initialX = randi_range(100, screen.x-100)
	var endX = randi_range(initialX - 50, initialX + 50)
	var endy = randi_range(screen.y/2, 100)
	tween.tween_method(_setRocketPosition, Vector2(initialX, screen.y), Vector2(endX, endy), 3)
	await tween.finished

func _setRocketPosition(value):
	position = value
