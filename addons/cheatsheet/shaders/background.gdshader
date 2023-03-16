shader_type canvas_item;

uniform float blur_amount: hint_range(0.0, 10.0) = 4.;
uniform float blur_mix: hint_range(0.0, 1.0) = 0.5;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;


void fragment() {
	COLOR.rgb = mix(COLOR.rgb, textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount).rgb, blur_mix);
}
