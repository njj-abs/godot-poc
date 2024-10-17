shader_type canvas_item;

#define iResolution 1.0/SCREEN_PIXEL_SIZE
#define iTime TIME

// Ripple center position from the touch input
uniform vec2 ripple_center = vec2(0.5, 0.5);
uniform float ripple_radius = 0.0; // Ripple expansion

// Ripple effect size
uniform float size  = 5.0;

uniform sampler2D iChannel0;

/* Ripple effect shader for single ripple on touch */

// Maximum number of cells a ripple can cross.
#define MAX_RADIUS 2

float hash12(vec2 p) {
    vec3 p3  = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

void fragment() {
    float resolution = size;
    vec2 uv = SCREEN_UV * resolution;

    // Center the ripple effect on the touch input position
    vec2 uv2 = uv * vec2(1.0, SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y);
    vec2 p0 = floor(uv2 - ripple_center * resolution);

    vec2 circles = vec2(0.0);
    for (int j = -MAX_RADIUS; j <= MAX_RADIUS; ++j) {
        for (int i = -MAX_RADIUS; i <= MAX_RADIUS; ++i) {
            vec2 pi = p0 + vec2(float(i), float(j));
            vec2 p = pi + vec2(hash12(pi));

            // Adjust ripple expansion based on the current radius
            float t = ripple_radius;
            vec2 v = p - uv2;
            float d = length(v) - (float(MAX_RADIUS) + 1.0) * t;

            float h = 1e-3;
            float d1 = d - h;
            float d2 = d + h;
            float p1 = sin(31.0 * d1) * smoothstep(-0.6, -0.3, d1) * smoothstep(0.0, -0.3, d1);
            float p2 = sin(31.0 * d2) * smoothstep(-0.6, -0.3, d2) * smoothstep(0.0, -0.3, d2);
            circles += 0.5 * normalize(v) * ((p2 - p1) / (2.0 * h) * (1.0 - t) * (1.0 - t));
        }
    }
    circles /= float((MAX_RADIUS * 2 + 1) * (MAX_RADIUS * 2 + 1));

    // Intensity of the ripple effect
    float intensity = 0.2 * (1.0 - ripple_radius);
    vec3 n = vec3(circles, sqrt(1.0 - dot(circles, circles)));
    vec3 color = texture(iChannel0, uv / resolution - intensity * n.xy).rgb;
    
    COLOR = vec4(color, 1.0);
}
