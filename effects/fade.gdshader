shader_type canvas_item;

uniform float fade : hint_range(0.0, 1.0, 0.1);

void fragment() {
	COLOR.a = clamp(texture(TEXTURE, UV).a - (fade / 1.0), 0.0, 1.0);
}
