import processing.svg.*;

int canvasX = 0;
int canvasY = 0;
int canvasW = 0;
int canvasH = 0;

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

int plotW;
int plotH;
int plotX;
int plotY;


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

    updateKeyDimensions();
    sketch = new Sketch(plotW, plotH, printResolution * screenScale);

    imgSaver = new ImageSaver();
    imgSaver.savePNG = savePNGPreview;
}


void updateKeyDimensions() {
    calculateScreenScale();
    calculatePlotArea();
    strokeWeight = calculateStrokeSize();

    println("page size: " + printWInches + " ✕ " + printHInches + " inches");
    println("scaled to: " + canvasW + " ✕ " + canvasH + " pixels\n");

    grid = new GraphPaper(maxPlotW, maxPlotH, printWInches, printHInches, printResolution * screenScale);
    if(sketch != null){
        sketch.setDimensions(plotW, plotH, printResolution * screenScale);
    }
}


void draw() {
    drawBG();
    translate(canvasX, canvasY);
    if(showGrid) grid.draw();

    translate(plotX, plotY);
    
    imgSaver.startSave();

    strokeWeight(strokeWeight / screenScale);
    sketch.draw(strokeWeight / screenScale);

    imgSaver.endSave(this.g, canvasX, canvasY, canvasW, canvasH); 
}

float calculateStrokeSize() {
    float size = (penSizeMM * 0.03937008) * printResolution * screenScale; 
    return size;
}

void calculateScreenScale() {
    float maxW = width - 100;
    float maxH = height - 100;
    
    float _printW = printWInches * printResolution;
    float _printH = printHInches * printResolution;

    screenScale = maxW / _printW;
    
    if(_printH * screenScale > maxH){
        screenScale = maxH / _printH;
    }
    
    if(screenScale > maxScreenScale){
        screenScale = maxScreenScale;
    }
    
    canvasW = int(printWInches * printResolution * screenScale);
    canvasH = int(printHInches * printResolution * screenScale);
    
    canvasX = (width - canvasW) /2;
    canvasY = (height - canvasH) /2;
}

void calculatePlotArea() {
    if(constrainToPlotArea){
        plotW = int(min(printWInches, maxPlotW) * printResolution * screenScale);
        plotH = int(min(printHInches, maxPlotH) * printResolution * screenScale);
        plotX = (canvasW - plotW) / 2;
        plotY = (canvasH - plotH) / 2;
    } else {
        plotW = canvasW;
        plotH = canvasH;
        plotX = 0;
        plotY = 0;
    }
}

void drawPaperBG() {
    stroke(80);
    strokeWeight(4);
    rect(canvasX, canvasY, canvasW, canvasH);

    fill(255);
    noStroke();
    rect(canvasX, canvasY, canvasW, canvasH);
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
    int _canvasW = canvasW;
    int _canvasH = canvasH;
    if(useRetinaDisplay){
        _canvasW *= 2;
        _canvasH *= 2;
    }
    imgSaver.begin(printWInches, printHInches, _canvasW, _canvasH);
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
