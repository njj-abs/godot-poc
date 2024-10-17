#extends TextureRect
#
#var shader_material: ShaderMaterial
#
#func _ready():
	## Assign the shader material to the TextureRect
	#shader_material = material
#
#func _input(event):
	#if event is InputEventScreenTouch or event is InputEventMouseButton:
		#if event.pressed:
			#var touch_position = event.position / size
			#shader_material.set_shader_parameter("ripple_center", touch_position)
			#shader_material.set_shader_parameter("ripple_radius", 0.0) # Start with radius 0
			#_start_ripple_effect()
#
#func _start_ripple_effect():
	## Create a single tween for ripple expansion
	#var tween = create_tween()
	#
	## Animate ripple radius from 0 to 1 (expansion) over 1 second
	#tween.tween_property(shader_material, "shader_parameter/ripple_radius", 1.0, 1.0)
	#
	## Optionally, connect the tween completion to hide/reset the ripple
	#await tween.finished
	#_on_ripple_complete()
#
#func _on_ripple_complete():
	## After the ripple effect completes, reset or hide the ripple
	#shader_material.set_shader_parameter("ripple_radius", 0.0)

extends TextureRect

var shader_material

func _ready():
	shader_material = material as ShaderMaterial

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		var ripple_size = shader_material.get_shader_parameter("size")

		var uv_position = Vector2(
			event.position.x / size.x,
			event.position.y / size.y
		)

		uv_position *= ripple_size

		shader_material.set_shader_parameter("touch_position", uv_position)
