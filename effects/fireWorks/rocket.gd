extends CPUParticles2D

var colors = [
	Color("red"),
	Color("green"),
	Color("yellow"),
]

func play():
	color = colors[randi_range(0, colors.size() - 1)]
	var screen = get_viewport_rect().size
	var tween = get_tree().create_tween()
	var initialX = randi_range(100, screen.x-100)
	var endX = randi_range(initialX, initialX + 50)
	var endy = randi_range(screen.y/2, 100)
	tween.tween_method(_setRocketPosition, Vector2(initialX, screen.y), Vector2(endX, endy), 1)
	await tween.finished

func _setRocketPosition(value):
	position = value
