shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec4 drop = vec4(0.4, 0.4, 1, 0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb = vec3(0.0);
	vec2 uvdrop = UV - drop.xy;
	COLOR.rg = abs(uvdrop);
	//COLOR = textureLod(screen_texture, UV, 0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
