shader_type canvas_item;

// GAUSSIAN BLUR SETTINGS {{{
uniform float Directions = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
uniform float Quality = 3.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
uniform float Size = 4.0; // BLUR SIZE (Radius)
// GAUSSIAN BLUR SETTINGS }}}

varying vec4 vertex_color;
void vertex() {
	
}

void fragment() {
	vec2 RESOLUTION = 1.0 / TEXTURE_PIXEL_SIZE;
	
	vec2 Radius = Size/RESOLUTION.xy;
    
    vec2 uv = UV;
    // Pixel colour
    vec4 Color = texture(TEXTURE, uv);
    
    // Blur calculations
    for( float d=0.0; d<TAU; d+=TAU/Directions)
    {
		for(float i=1.0/Quality; i<=1.001; i+=1.0/Quality)
        {
			Color += texture( TEXTURE, uv+vec2(cos(d),sin(d))*Radius*i);
        }
    }
    
    // Output to screen
    Color /= Quality * Directions + 1.0;
    COLOR =  Color;
}