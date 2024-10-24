shader_type canvas_item;

#define MAX_POINTS 2

uniform vec2 touch_positions[MAX_POINTS];
uniform float custom_times[MAX_POINTS]; // Custom time per ripple

uniform float size = 1.0;
uniform float speed = 0.1; // Speed of the ripple
uniform float frequency = 31.0; // Frequency of the ripple oscillations
uniform float max_radius = 1.0; // Maximum ripple radius
uniform float intensity = 0.15; // Intensity of the ripple effect
uniform float ripple_duration = 5.0; // Duration of each ripple

void fragment() {
	vec2 uv = SCREEN_UV * size;
	vec3 final_color = vec3(0.0);

	for (int i = 0; i < MAX_POINTS; i++) {
		// Process the ripple only if within valid time range
		if (custom_times[i] <= ripple_duration) {
			vec2 tp = touch_positions[i];
			vec2 v = uv - tp;
			float distance = length(v);

			// Use the custom time for each ripple instead of TIME
			float t = custom_times[i] * speed;

			// Fade-out effect: as custom_time approaches ripple_duration, the ripple fades
			float fade_factor = smoothstep(ripple_duration, ripple_duration * 0.8, custom_times[i]);

			// Calculate the ripple's progression over time
			float ripple = sin(frequency * (distance - max_radius * t)) * smoothstep(0.6, 0.0, distance - max_radius * t);

			// Apply the fade factor to the ripple to smoothly reduce its intensity at the end
			ripple *= fade_factor;

			// Create a normal for the ripple effect
			vec2 ripple_vec = normalize(v) * ripple * intensity;
			vec3 n = vec3(ripple_vec, sqrt(1.0 - dot(ripple_vec, ripple_vec)));

			// Sample the texture and apply ripple distortion
			vec3 rgbColor = texture(TEXTURE, uv / size - ripple_vec).rgb;

			// Add a lighting effect based on the ripple's normal
			float lighting = 5.0 * pow(clamp(dot(n, normalize(vec3(1.0, 0.7, 0.5))), 0.0, 1.0), 6.0);

			// Accumulate the color for each ripple, only if it's within the valid time range
			final_color += (rgbColor + lighting);
		}
	}

	// Normalize the final color based on the number of touch points (to avoid color being too bright)
	final_color /= float(MAX_POINTS);
	COLOR = vec4(final_color, 1.0);
}
