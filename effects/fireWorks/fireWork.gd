extends Node2D

const explosionScene = preload("res://effects/fireWorks/explosion.tscn")
const rocketScene = preload("res://effects/fireWorks/rocket.tscn")
const sparkScene = preload("res://effects/fireWorks/spark.tscn")

func _on_button_pressed():
	var rocket = rocketScene.instantiate()
	add_child(rocket)
	await rocket.play()
	var explosion = explosionScene.instantiate()
	var spark = sparkScene.instantiate()
	add_child(explosion)
	add_child(spark)
	explosion.position = rocket.position
	spark.position = rocket.position
	spark.emitting = true
	explosion.emitting = true
	rocket.queue_free()
	spark.finished.connect(_onSparkFinished.bind(spark))
	explosion.finished.connect(_onSparkFinished.bind(explosion))

func _onSparkFinished(node):
	node.queue_free()
