shader_type canvas_item;

#define MAX_POINTS 2

uniform vec2 touch_positions[MAX_POINTS];
uniform float start_time[MAX_POINTS];
uniform float end_time[MAX_POINTS];

// Add a custom time uniform
uniform float custom_times[MAX_POINTS];

uniform float size = 1.0;
uniform float speed = 0.1; // Speed of the ripple
uniform float frequency = 31.0; // Frequency of the ripple oscillations
uniform float max_radius = 1.0; // Maximum ripple radius
uniform float intensity = 0.15; // Intensity of the ripple effect


void fragment()
{
	vec2 uv = SCREEN_UV * size;
	vec3 final_color = vec3(0.0);

	for (int i = 0; i < MAX_POINTS; i++)
	{
 		int temp_num = 0;
		vec2 tp = touch_positions[i];
		vec2 v = uv - tp;
		float distance = length(v);
		// Use custom_time instead of TIME
		float time = smoothstep(start_time[i], end_time[i], TIME * speed);
		
		float t = fract(speed * custom_times[i]);
		float ripple = sin(frequency * (distance - max_radius * t)) * smoothstep(0.6, 0.0, distance - max_radius * t);

		vec2 ripple_vec = normalize(v) * ripple * intensity;
		vec3 n = vec3(ripple_vec, sqrt(1.0 - dot(ripple_vec, ripple_vec)));
		vec3 rgbColor = texture(TEXTURE, uv / size - ripple_vec).rgb;

		float lighting = 5.0 * pow(clamp(dot(n, normalize(vec3(1.0, 0.7, 0.5))), 0.0, 1.0), 6.0);
		//final_color += rgbColor + lighting;
		if (time <= 1.0) {
			final_color += rgbColor + lighting;
		}
	}

	final_color /= float(MAX_POINTS);
	COLOR = vec4(final_color, 1.0);
}
