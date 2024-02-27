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
	}

	float blur() {
		focused = false;
		trimStringVal(value);
		return value;
	}

	void trimStringVal(float v) {
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