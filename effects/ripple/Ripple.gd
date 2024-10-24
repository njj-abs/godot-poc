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

#func _process(delta):
	## Update custom time manually, for example, increase it by delta to progress
	#
	## If you want to reset or manipulate time, modify custom_time_value accordingly
	## Example of pausing time:
	#if custom_time_values > 5:
		#material.set_shader_parameter("custom_time", custom_time_values)
#
	## Example of reversing time:
	## custom_time_value -= delta
#
	## Set the custom time in the shader
	#else:
		#custom_time_values += delta
		#material.set_shader_parameter("custom_time", custom_time_values)

#func _input(event):
	#if event is InputEventScreenTouch and event.pressed:
		#var ripple_size = shader_material.get_shader_parameter("size")
#
		#var uv_position = Vector2(
			#event.position.x / size.x,
			#event.position.y / size.y
		#)
#
		#uv_position *= ripple_size
		#uv_positions.append(uv_position)
		#startTimes.append(0)
		#endTimes.append(1)
		#var ticks_in_seconds = Time.get_ticks_msec() / 1000.0
		#startTimes.append(ticks_in_seconds)
		#endTimes.append(ticks_in_seconds+10)
		##var touch_positions:PackedColorArray = [Vector4(uv_position.x,uv_position.y,0,1)]
		##shader_material.set_shader_parameter("touch_position", uv_position)
		##shader_material.set_shader_parameter("touch_position", touch_positions)
		#shader_material.set_shader_parameter("touch_positions", uv_positions)
		##shader_material.set_shader_parameter("touch_position_y", uv_positions_y)
		#shader_material.set_shader_parameter("start_time", startTimes)
		#shader_material.set_shader_parameter("end_time", endTimes)

extends TextureRect

var shader_material
var uv_positions:Array = []
var startTimes:Array = []
var endTimes:Array = []
var touch_positions = [Vector2(0, 0), Vector2(0, 0)]
var custom_time_values = []
var active_touches = 0
var ripple_duration = 5.0

func _ready():
	var array = []
	print(array.is_empty())
	shader_material = material as ShaderMaterial
	shader_material.set_shader_parameter("custom_time", custom_time_values)

func _process(delta):
	# Update custom times for active ripples
	for i in range(active_touches):
		# Only update if time is less than the ripple duration
		if custom_time_values[i] < ripple_duration:
			# Increment the custom time until it reaches the duration limit
			custom_time_values[i] += delta
		# Clamp the time value to ensure it doesn't exceed ripple_duration
		custom_time_values[i] = min(custom_time_values[i], ripple_duration)

		if custom_time_values[i] >= ripple_duration:
			custom_time_values.remove_at(i)
			active_touches -= 1

	# Update the shader with the new custom times
	_update_shader_params()


func _input(event):
	# If a touch event or mouse button event happens, update the touch position and reset custom time

	if event is InputEventScreenTouch and event.pressed:
		if active_touches < 2:
			var ripple_size = shader_material.get_shader_parameter("size")
			var uv_position = Vector2(
			event.position.x / size.x,
			event.position.y / size.y
		)

			uv_position *= ripple_size
			touch_positions[active_touches] = uv_position

			if custom_time_values.size() > active_touches:
				custom_time_values[active_touches] = 0.0  # Reset time for the new touch point
			else:
				custom_time_values.append(0.0)
			active_touches += 1

	_update_shader_params()

func _update_shader_params():
	# Update shader params for custom times and touch positions
	material.set_shader_parameter("custom_times", custom_time_values)
	material.set_shader_parameter("touch_positions", touch_positions)
