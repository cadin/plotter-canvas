class Sketch {
	int w; // width in pixels
	int h; // height in pixels
	float ppi; // pixels per inch of printed doc
	float strokeWeight;

	Sketch(){}

	void setDimensions(int _w, int _h, float _ppi, float _strokeWeight) {
		w = _w;
		h = _h;
		ppi = _ppi;
		strokeWeight = _strokeWeight;
	}

	void draw() {
		// replace this with custom sketch drawing code
		stroke(0);
		rect(ppi, ppi, ppi, ppi);
	}

	void keyPressed() {
		// keyPressed events get forwarded from main applet
	}

	void mousePressed() {
		// mousePressed events get forwarded from main applet
		// use mouseCanvasX and mouseCanvasY to get canvas coordinates
	}
}