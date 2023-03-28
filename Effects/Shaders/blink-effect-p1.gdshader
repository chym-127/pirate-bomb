shader_type canvas_item;

uniform bool active = false;

void fragment() {
	vec4 o_color = texture(TEXTURE,UV);
	vec4 white_color = vec4(1.0,1.0,1.0,o_color.a);
	if(active){
		o_color = white_color;
	}
	COLOR = o_color;
}
