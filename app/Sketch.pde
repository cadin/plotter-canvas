class Sketch extends PlotterCanvas {
	// vars available in the Sketch:

	// int w, h;                       -- width & height in pixels
	// float ppi;                      -- pixels per inch of current canvas
	// float strokeWeight;             -- the scaled stroke weight for the sketch
	// int canvasMouseX, canvasMouseY; -- mouse position in canvas coordinates

	Sketch(){}

	void draw() {
		// replace this with custom sketch drawing code
		rect((w -ppi) / 2, (h - ppi) / 2, ppi, ppi);
	}

	void mousePressed() {
		// mousePressed events get forwarded from main applet
		// use canvasMouseX and canvasMouseY to get canvas coordinates
	}

	// you can use these common functions too
	// void mouseReleased() {}
	// void keyPressed() {}
	// void keyReleased() {}

	// TODO: move this to the README docs
	// this gets called anytime canvas dimensions change
	// uncomment if you need to respond to size changes
	// void setDimensions(int _w, int _h, float _ppi, float _strokeWeight) {
	// 	super.setDimensions(_w, _h, _ppi, _strokeWeight); // you must call super
	// }
	
}