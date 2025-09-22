shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 5.0) = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
void fragment() {
    vec4 sum = vec4(0.0);
    float blur_size = blur_amount * 0.005;

    // A simple box blur algorithm
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-blur_size, -blur_size));
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, -blur_size));
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(blur_size, -blur_size));
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-blur_size, 0.0));
    sum += texture(SCREEN_TEXTURE, SCREEN_UV);
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(blur_size, 0.0));
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-blur_size, blur_size));
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, blur_size));
    sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(blur_size, blur_size));

    COLOR = sum / 9.0;
}