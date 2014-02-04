
public class Limb {
	color col = color(255,255,255);
	PVector point1, point2, midPoint, polar;
	float scaleFactorY, scaleFactorZ;

	public Limb(PVector p1, PVector p2, float _scaleFactorY, float _scaleFactorZ ) {
	    point1 = p1;
	    point2 = p2;
	    scaleFactorY = _scaleFactorY;
	    scaleFactorZ = _scaleFactorZ;
		midPoint = new PVector( (point1.x+point2.x)/2.f, (point1.y+point2.y)/2.f, (point1.z+point2.z)/2.f );
		PVector fromOrigin = new PVector();
		fromOrigin.set(point2);
		fromOrigin.sub(midPoint);
		polar = cartesianToPolar( fromOrigin );
	}

	public float draw() {
		pushStyle();
			pushMatrix();
				noStroke();
				fill(col);
				translate(midPoint.x,midPoint.y,midPoint.z);
				rotateY( polar.y );
				rotateZ( polar.z );
				scale(1,scaleFactorY,scaleFactorZ);
				sphere(polar.x);
			popMatrix();
		popStyle();

		return polar.x;
	}

	PVector cartesianToPolar(PVector v) {
	  PVector res = new PVector();
	  res.x = v.mag();
	  if (res.x > 0) {
	    res.y = -atan2(v.z, v.x);
	    res.z = asin(v.y / res.x);
	  } 
	  else {
	    res.y = 0;
	    res.z = 0;
	  }
	  return res;
	}
}
