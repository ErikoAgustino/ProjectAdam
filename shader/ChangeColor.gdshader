shader_type canvas_item;

uniform int select : hint_range(0, 5) = 0;

void fragment(){
	vec4 pixelColor = texture(TEXTURE, UV);
	COLOR = pixelColor;
	if(select == 0){
		COLOR.rgb = COLOR.rgb;
	}else if(select == 1){
		COLOR.rgb = COLOR.rbg;
	}else if(select == 2){
		COLOR.rgb = COLOR.gbr;
	}else if(select == 3){
		COLOR.rgb = COLOR.bgr;
	}else if(select == 4){
		COLOR.rgb = COLOR.grb;
	}else if(select == 5){
		COLOR.rgb = COLOR.brg;
	}
}