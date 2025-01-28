shader_type canvas_item;
render_mode blend_add;
// shaders used:
// https://godotshaders.com/shader/various-canvas-outlines/
// https://godotshaders.com/shader/glowing-rect-2d/

uniform vec2 rect_size = vec2(0.1, 0.1);
uniform float bness = 1.0;
uniform float fall_off_scale = 3.0;
uniform float b_offset = 0.0;
uniform float speed : hint_range(0.0, 10.0) = 1.0;
uniform float noise_intensity : hint_range(0.0, 1.0) = 0.5;


// Pseudorandom number
float hash(vec2 p, float s) {
    return fract(35.1 * sin(dot(vec3(112.3, 459.2, 753.2), vec3(p, s))));
}

// Noise function
float noise(vec2 p, float s) {
    vec2 d = vec2(0, 1);
    vec2 b = floor(p);
    vec2 f = fract(p);
    return mix(
        mix(hash(b + d.xx, s), hash(b + d.yx, s), f.x),
        mix(hash(b + d.xy, s), hash(b + d.yy, s), f.x), f.y
    );
}

void fragment() {
    vec2 uv = UV - vec2(0.5);
    vec2 closest_rect_point;
    closest_rect_point = uv;
    closest_rect_point.x = clamp(uv.x, -rect_size.x, rect_size.x);
    closest_rect_point.y = clamp(uv.y, -rect_size.y, rect_size.y);

    vec2 cuv = uv - closest_rect_point;
    float d2c = length(cuv);

	// time-based noise to animate the outline
    float time_step = floor(TIME * speed);
    float animated_falloff = fall_off_scale + noise(uv * 10.0, time_step) * noise_intensity;

	// alpha calculation with animation
    COLOR.a = -log(d2c * animated_falloff + b_offset) * bness;
}
