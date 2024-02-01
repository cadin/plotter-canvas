import processing.svg.*;

int canvasXPx = 0;
int canvasYPx = 0;
int canvasWPx = 0;
int canvasHPx = 0;

float maxScreenScale;
float screenScale; 
float penSizeMM;
float printWInches;
float printHInches;
int printResolution = 72;
float marginInches = 0;	
float strokeWeight;

Sketch sketch;
ImageSaver imgSaver;

GraphPaper grid;
boolean showGrid = false;

int plotWPx;
int plotHPx;
int plotXPx;
int plotYPx;

float plotWInches;
float plotHInches;

float maxPlotWInches;
float maxPlotHInches;

int mouseCanvasX = 0;
int mouseCanvasY = 0;


void settings() {
	
    if(fullscreen) {
    	fullScreen();
    } else {
        size(displayWidth, displayHeight - 45);
	    // size(1920, 1080);
    }
	if(useRetinaDisplay){
		pixelDensity(displayDensity());
	}
}

void setup() {
    maxScreenScale = displayScale * 300 / printResolution;
    penSizeMM = penSize;
    printWInches = printW;
    printHInches = printH;

    maxPlotWInches = maxPlotW;
    maxPlotHInches = maxPlotH;

    updateKeyDimensions();
    sketch = new Sketch(plotWPx, plotHPx, printResolution * screenScale);

    imgSaver = new ImageSaver();
    imgSaver.savePNG = savePNGPreview;
}


void updateKeyDimensions() {
    calculateScreenScale();
    calculatePlotArea();
    strokeWeight = calculateStrokeSize();

    println("page size: " + printWInches + " ✕ " + printHInches + " inches");
    println("scaled to: " + canvasWPx + " ✕ " + canvasHPx + " pixels\n");

    grid = new GraphPaper(maxPlotWInches, maxPlotHInches, printWInches, printHInches, printResolution * screenScale);
    if(sketch != null){
        sketch.setDimensions(plotWPx, plotHPx, printResolution * screenScale);
    }
}


void draw() {
    drawBG();
    translate(canvasXPx, canvasYPx);

    if(showGrid) grid.draw();

    translate(plotXPx, plotYPx);
    imgSaver.startSave();
    sketch.draw(strokeWeight);

    imgSaver.endSave(get(), canvasXPx, canvasYPx, canvasWPx, canvasHPx); 
}

float calculateStrokeSize() {
    // 1mm = 0.03937008 inches
    float size = (penSizeMM * 0.03937008) * printResolution * screenScale; 
    return size;
}

void calculateScreenScale() {
    float maxW = width - 100;
    float maxH = height - 100;
    
    float _printWPx = printWInches * printResolution;
    float _printHPx = printHInches * printResolution;

    screenScale = maxW / _printWPx;
    
    if(_printHPx * screenScale > maxH){
        screenScale = maxH / _printHPx;
    }
    
    if(screenScale > maxScreenScale){
        screenScale = maxScreenScale;
    }
    
    canvasWPx = int(printWInches * printResolution * screenScale);
    canvasHPx = int(printHInches * printResolution * screenScale);
    
    canvasXPx = (width - canvasWPx) /2;
    canvasYPx = (height - canvasHPx) /2;
}

void calculatePlotArea() {
    if(constrainToPlotArea){
        float mpw = maxPlotWInches;
        float mph = maxPlotHInches;
        if(printWInches < printHInches){
            // portrait
            mpw = maxPlotHInches;
            mph = maxPlotWInches;
        }

        plotWInches = min(printWInches, mpw);
        plotHInches = min(printHInches, mph);

        plotWPx = int(plotWInches * printResolution * screenScale);
        plotHPx = int(plotHInches * printResolution * screenScale);

        plotXPx = (canvasWPx - plotWPx) / 2;
        plotYPx = (canvasHPx - plotHPx) / 2;
    } else {
        plotWPx = canvasWPx;
        plotHPx = canvasHPx;

        plotWInches = printWInches;
        plotHInches = printHInches;

        plotXPx = 0;
        plotYPx = 0;
    }
}

void drawPaperBG() {
    stroke(80);
    strokeWeight(4);
    rect(canvasXPx, canvasYPx, canvasWPx, canvasHPx);

    fill(255);
    noStroke();
    rect(canvasXPx, canvasYPx, canvasWPx, canvasHPx);
}

void drawBG() {
    background(100);
    if(imgSaver.isBusy()){ drawSaveIndicator();}
    drawPaperBG();
    
}

void drawSaveIndicator() {
    pushMatrix();
        fill(color(200, 0, 0));
        noStroke();
        rect(0,0,width, 4);
    popMatrix();
}

void saveImage() {
    int _plotWPx = plotWPx;
    int _plotHPx = plotHPx;
    if(useRetinaDisplay){
        _plotWPx *= 2;
        _plotHPx *= 2;
    }

    imgSaver.begin(plotWInches, plotHInches, _plotWPx , _plotHPx);
}

void mousePressed() {
	mouseCanvasX = mouseX - canvasXPx;
	mouseCanvasY = mouseY - canvasYPx;

	sketch.mousePressed();
}

void keyPressed() {
    switch(key) {
        case 's' :
            saveImage();
        break;
        case 'g': 
            showGrid = !showGrid;
        break;
    }

    sketch.keyPressed();
}
