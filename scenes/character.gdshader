shader_type canvas_item;
const float precision = 0.1;
//uniform vec4 chroma_key: source_color = vec4(248.0,0.0,248.0,255.0);
//uniform vec4 chroma_key_replace: source_color = vec4(0.0,0.0,0.0,0.0);
//uniform float tolerance: hint_range(0.0,1.0) = 0.5;
uniform sampler2D palette;
uniform vec4 color1: source_color = vec4(68.0,88.0,219.0,255.0);
uniform vec4 color2: source_color = vec4(69.0,118.0,255.0,255.0);
uniform vec4 color3: source_color = vec4(248.0,0.0,248.0,255.0);
//New palette
uniform vec4 newColor1: source_color = vec4(68.0,88.0,219.0,255.0);
uniform vec4 newColor2: source_color = vec4(69.0,118.0,255.0,255.0);
uniform vec4 newColor3: source_color = vec4(248.0,0.0,248.0,255.0);

vec4 swap_color(vec4 color){
	vec4 original_colors[3] = vec4[3] (color1, color2, color3);
	vec4 replace_colors[3] = vec4[3] (newColor1, newColor2, newColor3);
	for (int i = 0; i < 3; i ++) {
		if (distance(color, original_colors[i]) <= precision){
			return replace_colors[i];
		}
	}
	return color;
}

void fragment(){
	vec4 color_a = texture(TEXTURE, UV);
	//if (color_a.r < 248.0 && color_a.g == 0.0 && color_a.b < 248.00) { //Opacity
        //color_a.a = 0.0;
    //}
	COLOR = swap_color(color_a);
}
