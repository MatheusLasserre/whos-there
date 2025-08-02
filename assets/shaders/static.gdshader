shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform float amount = 40.0;
//uniform float max_alpha = 128.0;

void fragment() {
	vec2 uv = SCREEN_UV*0.05;
	float a = fract(sin(dot(SCREEN_UV, vec2(12.9898, 78.233) * TIME)) * 438.5453) * 1.9;
	vec4 col = texture(SCREEN_TEXTURE, SCREEN_UV);
	col.a *= pow(a, amount);
	COLOR.a = col.a;
}