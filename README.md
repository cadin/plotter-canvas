# plotter-canvas

An empty canvas for building plotter art in Processing.

This projects runs full screen (optional) with a proportional canvas showing your sketch in context of the target print size. Output your sketch as plot-ready SVG with optional PNG preview.

## Getting Started

### Requirements

- [Processing 4](https://processing.org/download)

### Setup

Put your sketch code in the `Sketch.pde` file.

The main app will call your sketch's `draw` method once per frame.

#### Config

Set your paper size, pen thickness, and display scaling in the `config.pde` file.

## Usage

Any drawing commands in your sketch's `draw` method will be output to SVG when saving.

Use the `w`, `h`, and `ppi` variables in to your sketch to position your drawing on the canvas.

### Mouse & Keyboard Input

You can use these Processing functions in your sketch to access mouse and keyboard input:  
[`mousePressed()`](https://processing.org/reference/mousePressed_.html)  
[`mouseReleased()`](https://processing.org/reference/mouseReleased_.html)  
[`keyPressed()`](https://processing.org/reference/keyPressed_.html)  
[`keyReleased()`](https://processing.org/reference/keyReleased_.html)

Use `canvasMouseX` and `canvasMouseY` to get mouse coordinates relative to the canvas.

### Responding to Canvas Size Changes

If you need to do something in your project to respond to a change in canvas size, you can implement the `setDimensions` function:

```java
void setDimensions(int _w, int _h, float _ppi, float _strokeWeight) {
	super.setDimensions(_w, _h, _ppi, _strokeWeight); // you must call super

	// your code here...
}
```

This function will be called by `app.pde` any time the canvas size changes. Be sure to call super in order to have the parent class correctly update the canvas values.

### Key Commands

**`s`** : Save a plot-ready SVG. This also saves a PNG preview image if you have that flag set in the config file.

**`g`** : Toggle a visual grid that represents the maximum plot area.

## Support

This is a personal project and is mostly unsupported, but I'm happy to hear feedback or answer questions.

## License

This project is licensed under the Unlicense - see the [LICENSE](LICENSE) file for details.

---

👨🏻‍🦲❤️🛠
