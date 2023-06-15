import java.util.regex.Pattern; 
import java.util.regex.Matcher;

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

		// if(saveSVG && !didSaveSVG){
		// 	didSaveSVG = true;
		// } else if(savePNG && !didSavePNG){
		// 	didSavePNG = true;
		// } else {
		// 	state = SaveState.COMPLETE;
		// }
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
				// saveImageData(filename);
				if(mode == SaveMode.SVG){
					resizeSVG(filename, printW, printH, canvasW, canvasH);
				}
				// state = SaveState.COMPLETE;
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

	void endSave(PGraphics appGraphics, int x, int y, int w, int h) {
		if(state == SaveState.SAVING) {
			if(mode == SaveMode.SVG){
				endRecord();
				println("done!");
			} else {
				savePreview(appGraphics, x, y, w, h);
			}
		}
		update();
	}

	void savePreview(PGraphics appGraphics, int x, int y, int w, int h) {
		print("- saving PNG preview... ");
		PGraphics preview = createGraphics(w, h);
		preview.beginDraw();
			preview.background(255);
			preview.image(appGraphics, -x, -y);
		preview.endDraw();
		preview.save("output/" + filename + ".png");
		println("done!");
	}
	
	void saveImageData(String filename) {
		print("writing data file... ");
		
		// JSONArray cellArray = getBlackoutCellArray();
		// JSONArray graphicsArray = getGraphicSetsArray();
		
		// JSONObject obj = new JSONObject();
		// obj.setJSONArray("blackoutCells", cellArray);
		// obj.setFloat("printWidthInches", PRINT_W_INCHES);
		// obj.setFloat("printHeightInches", PRINT_H_INCHES);
		// obj.setInt("printResolution", PRINT_RESOLUTION);
		// obj.setInt("gridWidth", GRID_W);
		// obj.setInt("gridHeight", GRID_H);
		// obj.setFloat("marginInches", MARGIN_INCHES);
		// obj.setBoolean("useTwists", useTwists);
		// obj.setBoolean("useJoiners", useJoiners);
		// obj.setBoolean("allowOverlap", allowOverlap);
		// obj.setFloat("noodleThicknessPct", noodleThicknessPct);
		// obj.setInt("numNoodles", numNoodles);
		// obj.setInt("minLength", minLength);
		// obj.setInt("maxLength", maxLength);
		// obj.setJSONArray("graphics", graphicsArray);
		// obj.setBoolean("randomizeEnds", randomizeEnds);
		// saveJSONObject(obj, "output/" + filename + ".json");
		// // saveJSONArray(layersArray, "output/" + filename + ".json");
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

