
public class Joint {
	color col = color(255,255,255);
	PVector point1;
	float radius;

	public Joint(PVector p1, float _r) {
	    point1 = p1;
	    radius = _r;
	}

	public void draw() {
		pushStyle();
			pushMatrix();
				noStroke();
				fill(col);
				translate(point1.x,point1.y,point1.z);
				scale(0.3f);
				sphere(radius);
			popMatrix();
		popStyle();
	}

}
