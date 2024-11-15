extends Node2D

const explosionScene = preload("res://effects/fireWorks/explosion.tscn")
const rocketScene = preload("res://effects/fireWorks/rocket.tscn")
const sparkScene = preload("res://effects/fireWorks/spark.tscn")

var colors = [
	Color("red"),
	Color("green"),
	Color("yellow"),
]

func _on_button_pressed():
	var color = colors[randi_range(0, colors.size() - 1)]
	var rocket = rocketScene.instantiate()
	add_child(rocket)
	rocket.color = color
	await rocket.play()
	var explosion = explosionScene.instantiate()
	var spark = sparkScene.instantiate()
	add_child(explosion)
	add_child(spark)
	explosion.position = rocket.position
	spark.position = rocket.position
	spark.color = color
	explosion.color = color
	spark.emitting = true
	explosion.emitting = true
	rocket.emitting = false
	spark.finished.connect(_onSparkFinished.bind(spark, rocket))
	explosion.finished.connect(_onExplosionFinished.bind(explosion))

func _onSparkFinished(node, rocket):
	rocket.queue_free()
	node.queue_free()

func _onExplosionFinished(node):
	node.queue_free()
