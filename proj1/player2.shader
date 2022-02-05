shader_type canvas_item;

uniform vec2 image_size = vec2(32, 32);
//const vec2 kernel_size = vec2(4.0, 4.0);

void fragment() {
//	vec2 uv = floor(UV * image_size)/(image_size - 1.0);
	vec2 uv = ceil(UV * image_size)/(image_size + 1.0);
	COLOR = texture(TEXTURE, uv);
}