class Sketch {
    int w; // width in pixels
    int h; // height in pixels
    float ppi; // pixels per inch of printed doc

    Sketch(int _w, int _h, float _ppi) {
        w = _w;
        h = _h;
        ppi = _ppi;
    }

    void setDimensions(int _w, int _h, float _ppi) {
        w = _w;
        h = _h;
        ppi = _ppi;
    }

    void draw(float penSize) {
        // replace this with custom sketch drawing code
        strokeWeight(penSize);
    }

    void keyPressed() {
        // keyPressed events get forwarded from main applet
    }

    void mousePressed() {
        // mousePressed events get forwarded from main applet
        // use mouseCanvasX and mouseCanvasY to get canvas coordinates
    }
}