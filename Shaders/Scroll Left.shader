shader_type canvas_item;
uniform float scroll_speed;

uniform float time;


void fragment() {
	vec2 shifteduv;
	vec4 color;
	shifteduv = UV;
	shifteduv.x += time * scroll_speed;
	color = texture(TEXTURE,shifteduv);
	COLOR = color;
}