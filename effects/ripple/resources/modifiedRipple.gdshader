shader_type canvas_item;

uniform vec2 touch_position = vec2(0.5, 0.5); // Initial touch position (centered by default)
uniform float size = 1.0;
uniform float speed = 0.1; // Speed of the ripple
uniform float frequency = 31.0; // Frequency of the ripple oscillations
uniform float max_radius = 1.0; // Maximum ripple radius
uniform float intensity = 0.15; // Intensity of the ripple effect

void fragment()
{
    // Scale UV coordinates
    vec2 uv = SCREEN_UV * size;
    
    // Distance from the touch position
    vec2 v = uv - touch_position;
    float distance = length(v);
    
    // Animate the ripple
    float t = fract(speed * TIME);
    float ripple = sin(frequency * (distance - max_radius * t)) * smoothstep(0.6, 0.0, distance - max_radius * t);
    
    // Create a normal for lighting
    vec2 ripple_vec = normalize(v) * ripple * intensity;
    vec3 n = vec3(ripple_vec, sqrt(1.0 - dot(ripple_vec, ripple_vec)));
    
    // Sample the texture and apply the ripple distortion
    vec3 rgbColor = texture(TEXTURE, uv / size - ripple_vec).rgb;
    
    // Add a light effect based on the ripple normal
    float lighting = 5.0 * pow(clamp(dot(n, normalize(vec3(1.0, 0.7, 0.5))), 0.0, 1.0), 6.0);
    vec3 color = rgbColor + lighting;
    
    // Output final color
    COLOR = vec4(color, 1.0);
}
