extends TextureRect

var shader_material: ShaderMaterial
var custom_time_values = []
var touch_positions = [Vector2(0, 0), Vector2(0, 0)]
var active_touches = 0
var ripple_duration = 5.0
var max_ripples = 2

func _ready():
	shader_material = material as ShaderMaterial
	_update_shader_params()

func _process(delta):
	# Use a separate array to mark indices for removal
	var remove_indices = []

	# Update custom times for active ripples
	for i in range(active_touches):
		if custom_time_values[i] < ripple_duration:
			custom_time_values[i] += delta
		else:
			# Mark ripples that have exceeded their time limit
			remove_indices.append(i)

	# Remove ripples that have completed their animation
	# Iterate backwards to avoid issues with index shifting
	for i in remove_indices.size():
		custom_time_values.remove_at(i)
		touch_positions.remove_at(i)
		active_touches -= 1

	# Update the shader with the new custom times
	_update_shader_params()

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		if active_touches < max_ripples:
			var ripple_size = shader_material.get_shader_parameter("size")
			var uv_position = Vector2(
				event.position.x / size.x,
				event.position.y / size.y
			)

			uv_position *= ripple_size
			if active_touches >= touch_positions.size():
				touch_positions.append(uv_position)
			else:
				touch_positions[active_touches] = uv_position

			# Reset the ripple time for this touch
			if active_touches >= custom_time_values.size():
				custom_time_values.append(0.0)
			else:
				custom_time_values[active_touches] = 0.0

			# Increment active touches
			active_touches += 1

			# Immediately update the shader after a new touch event
			_update_shader_params()

func _update_shader_params():
	shader_material.set_shader_parameter("custom_times", custom_time_values)
	shader_material.set_shader_parameter("touch_positions", touch_positions)
