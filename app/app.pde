import processing.svg.*;

// SCREEN SCALES
float MACBOOK_15_SCALE = 0.4912;
float MACBOOK_13_SCALE = 0.5;
float LG_DISPLAY_SCALE = 0.366;

// PEN SIZES  (MM)
float RAPIDOGRAPH_0 = 0.35;
float RAPIDOGRAPH_7 = 2.0;
float BIC_INTENSITY = 0.5;
float POSCA_3M = 1.2;
float POSCA_5M = 2.4;
float PILOT_V5 = 0.5;
float PILOT_V7 = 0.7;

// APP VARS
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


void settings() {
	
    if(FULLSCREEN) {
    	fullScreen();
    } else {
        size(displayWidth, displayHeight - 45);
	    // size(1920, 1080);
    }
	if(USE_RETINA){
		pixelDensity(displayDensity());
	}
}

void setup() {
    maxScreenScale = _screenSize * 300 / printResolution;
    penSizeMM = _penSize;
    printWInches = _printW;
    printHInches = _printH;

    sketch = new Sketch();

    updateKeyDimensions();

    imgSaver = new ImageSaver();
    imgSaver.savePNG = _savePNGPreview;
}


void updateKeyDimensions() {
    calculateScreenScale();
    strokeWeight = calculateStrokeSize();

    println("page size: " + printWInches + " ✕ " + printHInches + " inches");
    println("scaled to: " + canvasW + " ✕ " + canvasH + " pixels\n");

    grid = new GraphPaper(printWInches, printHInches, printResolution * screenScale);
    sketch.setDimensions(canvasW, canvasH, printResolution * screenScale);
}


void draw() {
    drawBG();
    translate(canvasX, canvasY);
    if(showGrid) grid.draw();
    
    imgSaver.startSave();

    strokeWeight(strokeWeight / screenScale);
    sketch.draw(strokeWeight);

    imgSaver.endSave(this.g, canvasX, canvasY, canvasW, canvasH); 
}

float calculateStrokeSize() {
    float size = (penSizeMM * 0.03937008) * printResolution * screenScale; 
    return size;
}

void calculateScreenScale() {
    float maxW = width - 100;
    float maxH = height - 100;
    
    float printW = printWInches * printResolution;
    float printH = printHInches * printResolution;
    screenScale = maxW / printW;
    
    if(printH * screenScale > maxH){
        screenScale = maxH / printH;
    }
    
    if(screenScale > maxScreenScale){
        screenScale = maxScreenScale;
    }
    
    canvasW = int(printWInches * printResolution * screenScale);
    canvasH = int(printHInches * printResolution * screenScale);
    
    canvasX = (width - canvasW) /2;
    canvasY = (height - canvasH) /2;
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
    if(USE_RETINA){
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
