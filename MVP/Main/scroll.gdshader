shader_type canvas_item;

uniform int difficulty = 1;
uniform int newTime = 0;
uniform int startTime = 0;

void vertex() {
	// Called for every vertex the material is visible on.
	//UV.x += (TIME*0.29) + (float(difficulty) * 20.0);
	UV.x += ((TIME - float(startTime))*0.195)*(1.0 + (float(difficulty) * 0.001)) * 1.485;
	//UV.x += (float(newTime)*0.00375)*(1.0 + (float(difficulty) * 0.001));
	//UV.x += (float(difficulty) * 200.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
