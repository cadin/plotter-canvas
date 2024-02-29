class PlotterCanvas {
	int w; // width in pixels
	int h; // height in pixels
	float ppi; // pixels per inch of printed doc
	float strokeWeight; // the scaled stroke weight for the sketch

	PlotterCanvas() {}

	// this gets called whenever the canvas size changes
	// you can override it in Sketch, but make sure to call super
	void setDimensions(int _w, int _h, float _ppi, float _strokeWeight) {
		w = _w;
		h = _h;
		ppi = _ppi;
		strokeWeight = _strokeWeight;
	}

	// these all get overridden in the Sketch
	void draw() {}
	void mousePressed() {}
	void mouseReleased() {}
	void keyPressed() {}
	void keyReleased() {}
}