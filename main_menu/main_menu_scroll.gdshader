shader_type canvas_item;

uniform float speed_x = 0.1;   
uniform float speed_y = 2.0;       	
uniform float frequency_y = 2.0;   
uniform float amplitude_y = 0.05;

void vertex() {
	// Called for every vertex the material is visible on.
	UV.x += fract(TIME * speed_x);
    UV.y += sin(UV.y * frequency_y + TIME * speed_y) * amplitude_y;
	
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
