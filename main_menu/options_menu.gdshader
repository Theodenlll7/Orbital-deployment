shader_type canvas_item;

uniform float speed_x = 0.1;   
uniform float speed_y = 0.001;       	
uniform float frequency_x = 2.0;   
uniform float amplitude_x = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
	UV.y += fract(TIME * speed_y);
    UV.x += sin(UV.x * frequency_x + TIME * speed_x) * amplitude_x;
	
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
