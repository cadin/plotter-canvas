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
int printResolution = 144;
float marginInches = 0;	
float strokeWeight;

Sketch sketch;
ImageSaver imgSaver;

GraphPaper grid;
boolean showGrid = false;
boolean showUI = false;

int plotWPx;
int plotHPx;
int plotXPx;
int plotYPx;

float plotWInches;
float plotHInches;

float maxPlotWInches;
float maxPlotHInches;

int canvasMouseX = 0;
int canvasMouseY = 0;

Field printWField;
Field printHField;
Field focusedField;
String fieldStringVal = "";

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

	sketch = new Sketch();
	updateKeyDimensions();

	imgSaver = new ImageSaver();
	imgSaver.savePNG = savePNGPreview;

	printWField = new Field(10, 10, printWInches, "W");
	printHField = new Field(72, 10, printHInches, "H");
}


void updateKeyDimensions() {
	calculateScreenScale();
	calculatePlotArea();
	strokeWeight = calculateStrokeSize();

	println("page size: " + printWInches + " ✕ " + printHInches + " inches");
	println("scaled to: " + canvasWPx + " ✕ " + canvasHPx + " pixels (" + screenScale + " scale)\n ");

	grid = new GraphPaper(maxPlotWInches, maxPlotHInches, printWInches, printHInches, printResolution * screenScale);
	if(sketch != null){
		sketch.setDimensions(plotWPx, plotHPx, screenScale, printResolution * screenScale, strokeWeight);
	}
}


void draw() {
	drawBG();
	if(showUI) drawUI();
	translate(canvasXPx, canvasYPx);

	if(showGrid) grid.draw();

	translate(plotXPx, plotYPx);
	imgSaver.startSave();
	strokeWeight(strokeWeight);
	
	stroke(0);
	noFill();
	sketch.draw();

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

void drawUI() {
	printWField.draw();
	printHField.draw();
	noFill();
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

void focusField(Field f) {
	f.focus();
	focusedField = f;
	fieldStringVal = "";
}

void mousePressed() {
	if(printWField.mouseIsOver() || printHField.mouseIsOver()) {
		handleFieldClick();
	} else {
		handleSketchClick();
	}

	canvasMouseX = mouseX - canvasXPx;
	canvasMouseY = mouseY - canvasYPx;

	sketch.mousePressed();
}

void handleSketchClick() {
	if(printWField.focused || printHField.focused){
		printWInches = printWField.blur();
		printHInches = printHField.blur();
		updateKeyDimensions();
	}
}

void handleFieldClick() {
	if(printWField.mouseIsOver()) {
		if(printWField.focused){
			printWInches = printWField.blur();
		} else {
			printHInches = printHField.blur();
			focusField(printWField);
		}
	} else {
		if(printHField.focused){
			printHInches = printHField.blur();
		} else {
			printWInches = printWField.blur();
			focusField(printHField);
		}
	}
	updateKeyDimensions();
}

void handleFieldInput() {
	if((key >= 48 && key <= 57) || key == '.') {
		fieldStringVal += key;	
	}

	if(keyCode == BACKSPACE){
		fieldStringVal = fieldStringVal.substring(0, max(0, fieldStringVal.length() - 1));
	}

	focusedField.setStringValue(fieldStringVal);

	if(keyCode == ENTER || keyCode == RETURN) {
		printWInches = printWField.blur();
		printHInches = printHField.blur();
		updateKeyDimensions();
	}
}


void keyPressed() {
	if(printWField.focused || printHField.focused){
		handleFieldInput();
	}

	switch(key) {
		case 's' :
			saveImage();
		break;
		case 'g': 
			showGrid = !showGrid;
			showUI = !showUI;
		break;
	}

	sketch.keyPressed();
}

void mouseReleased(){
	sketch.mouseReleased();
}
void keyReleased() {
	sketch.keyReleased();
}

// ----------------------------------------
// GRAPH PAPER
// ----------------------------------------

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

// ----------------------------------------
// IMAGE SAVER
// ----------------------------------------

import java.util.regex.Pattern; 
import java.util.regex.Matcher;

enum SaveState {
	NONE, 
	BEGAN, 
	SAVING, 
	COMPLETE, 
	RENDER_BEGAN, 
	RENDERING
}

enum SaveMode {
	SVG, PNG
}

class ImageSaver {

	SaveState state = SaveState.NONE;
	String filename;
	boolean saveSVG = true;
	boolean savePNG = true;

	boolean didSaveSVG = false;
	boolean didSavePNG = false;

	SaveMode mode = SaveMode.SVG;

	float printW, printH;
	int canvasW, canvasH;

	ImageSaver() {
		
	}
	
	void updateSaveMode() {
		if(mode == SaveMode.SVG){
			if(savePNG){
				mode = SaveMode.PNG;
			} else {
				state = SaveState.COMPLETE;
			}
		} else {
			state = SaveState.COMPLETE;
		}
	}

	void update() {
		switch (state) {
			case BEGAN:
				println("\nSaving... ");
				state = SaveState.SAVING;
			break;
			case RENDER_BEGAN:
				state = SaveState.RENDERING;
			break;
			case SAVING:
				if(mode == SaveMode.SVG){
					resizeSVG(filename, printW, printH, canvasW, canvasH);
				}
				updateSaveMode();
			break;
			case RENDERING:
				// runRenderQueue();
			break;
			case COMPLETE:
				println("DONE!");
				state = SaveState.NONE;
			break;	
		}
	}
	
	boolean isBusy() {
		return state == SaveState.BEGAN || 
		       state == SaveState.SAVING || 
		       state == SaveState.RENDER_BEGAN || 
		       state == SaveState.RENDERING;
	}
	
	void begin(float _printW, float _printH, int _canvasW, int _canvasH) {
		filename = getFileName();
		state = SaveState.BEGAN;
		didSavePNG = false;
		didSaveSVG = false;

		printW = _printW;
		printH = _printH;

		canvasW = _canvasW;
		canvasH = _canvasH;
		
		if(saveSVG){
			mode = SaveMode.SVG;
		} else if(savePNG){
			mode = SaveMode.PNG;
		}
	}

	void startSave() {
		if(state == SaveState.SAVING) {
			if(mode == SaveMode.SVG){
				print("- saving SVG... ");
				beginRecord(SVG, "output/" + filename + ".svg");
			}
		}
	}

	void endSave(PImage screenImage, int x, int y, int w, int h) {
		
		if(state == SaveState.SAVING) {
			if(mode == SaveMode.SVG){
				endRecord();
				println("done!");
			} else {
				savePreview(screenImage, x, y, w, h);
			}
		}
		update();
	}

	void savePreview(PImage screenImage, int x, int y, int w, int h) {
		print("- saving PNG preview... ");
		PGraphics preview = createGraphics(w, h);
		preview.beginDraw();
			preview.background(255);
			preview.image(screenImage, -x, -y);
		preview.endDraw();
		preview.save("output/" + filename + ".png");
		println("done!");
	}
	
	void resizeSVG(String filename, float wInches, float hInches, int wPx, int hPx){
		print("- resizing SVG... ");
		String[] lines = loadStrings("output/" + filename + ".svg");
		
		for(int i=0; i < lines.length; i++){
			String l = lines[i];
			if(l.length() > 4 && l.substring(0, 4).equals("<svg")){
				print(" found SVG tag... ");
				Pattern p = Pattern.compile("width=\"([0-9]+)\"");
				Matcher m = p.matcher(l);
				l = m.replaceAll("width=\"" + wInches + "in\"");
				
				Pattern p2 = Pattern.compile("height=\"([0-9]+)\"");
				Matcher m2 = p2.matcher(l);
				lines[i] = m2.replaceAll("height=\"" + hInches + "in\" viewBox=\"0 0 " + wPx + " " + hPx + "\"");
			}
		}
		saveStrings("output/" + filename + ".svg", lines);
		println("done!");
	}

	String getFileName() {
		String d  = str( day()    );  // Values from 1 - 31
		String mo = str( month()  );  // Values from 1 - 12
		String y  = str( year()   );  // 2003, 2004, 2005, etc.
		String s  = str( second() );  // Values from 0 - 59
		String min= str( minute() );  // Values from 0 - 59
		String h  = str( hour()   );  // Values from 0 - 23

		String date = y + "-" + mo + "-" + d + " " + h + "-" + min + "-" + s;
		String n = date;
		return n;
	}
}

// ----------------------------------------
// INPUT FIELD
// ----------------------------------------

class Field {
	float value;
	String stringValue = "";
	float x = 0;
	float y = 0;
	boolean focused = false;
	String label = "";

	Field(float x, float y, float value, String label) {
		this.x = x;
		this.y = y;
		setValue(value);
		trimStringVal(value);
		this.label = label;
	}

	void setValue(float v) {
		value = v;
		stringValue = str(value);
	}

	void setStringValue(String s) {
		stringValue = s;
		value = float(s);
	}

	void draw() {		
		if(mouseIsOver() || focused){
			fill(200);
		} else {
			fill(150);
		}

		if(focused){
			fill(255);
			stroke(0, 255, 255);
			strokeWeight(1);
		} else {
			noStroke();
		}

		rect(x + 14, y, 44, 20, 4);
		fill(0);
		textAlign(RIGHT);
		text(label, x + 10, y + 14);
		textAlign(LEFT);
		text(stringValue, x + 18, y + 14);
	}

	void focus() {
		focused = true;
		stringValue = "";
	}

	float blur() {
		focused = false;
		trimStringVal(value);
		return value;
	}

	void trimStringVal(float v) {
		stringValue = str(v);
		// trim trailing zeros
		if(stringValue.indexOf(".") > 0){
			stringValue = stringValue.replaceAll("0*$", "");
			stringValue = stringValue.replaceAll("\\.$", "");
		}
	}

	boolean mouseIsOver() {
		return mouseX > x && mouseX < x + 50 && mouseY > y && mouseY < y + 20;
	}
}