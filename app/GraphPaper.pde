class GraphPaper {

    // max plotter dimensions in inches
    float maxW;
    float maxH;

    // offset to center grid on paper
    float x = 0;
    float y = 0;

    float ppi;

    GraphPaper(float _maxW, float _maxH, float _w, float _h, float _ppi) {
        maxW = _maxW;
        maxH = _maxH;

        if(_h > _w) setPortrait();
        
        maxW = min(maxW, _w);
        maxH = min(maxH, _h);

        x = (_w - maxW) / 2 * _ppi;
        y = (_h - maxH) / 2 * _ppi;

        ppi = _ppi;
    }

    void setPortrait() {
        float tempH = maxH;
        maxH = maxW;
        maxW = tempH;
    }

    void draw() {
        stroke(150, 255, 255);
        strokeWeight(1);
        noFill();

        int cols = round( maxW * 2) + 1;
        int colStart = 0;
        if(x <= 0) {
            colStart = 1;
            cols -= 1;
        }
        for(int i = colStart; i < cols; i++) {
            if(i % 2 == 0) {
                strokeWeight(1);
            } else {
                strokeWeight(0.5);
            }
            line(i * ppi /2 + x, y, i * ppi /2 + x, maxH * ppi + y);
        }

        int rows = round(maxH * 2) + 1;
        int rowStart = 0;
        if(y <= 0) {
            rowStart = 1;
            rows -= 1;
        }
        for(int i = rowStart; i < rows; i++) {
            if(i % 2 == 0) {
                strokeWeight(1);
            } else {
                strokeWeight(0.5);
            }
            line(x, i * ppi /2 + y, maxW * ppi + x, i * ppi /2 + y);
        }

    }
}