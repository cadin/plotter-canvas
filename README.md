# plotter-canvas

An empty canvas for building plotter art in Processing.

This projects runs full screen (optional) with a proportional canvas showing your sketch in context of the target print size. Output your sketch as plot-ready SVG with optional PNG preview.

## Getting Started

### Requirements

-   [Processing 4](https://processing.org/download)

### Setup

Put your sketch code in the `Sketch.pde` file.

The main app will call your sketch's `draw` method once per frame.

#### Config

Set your paper size, pen thickness, and display scaling in the `config.pde` file.

## Usage

Any drawing commands in your sketch's `draw` method will be output to SVG when saving.

Use the `w`, `h`, and `ppi` variables passed to your sketch to position your drawing on the canvas.

### Key Commands

`s` : Save a plot-ready SVG. This also saves a PNG preview image if you have that flag set in the config file.

`g` : Toggle a grid that represents the maximum plot area.

## License

This project is licensed under the Unlicense - see the [LICENSE](LICENSE) file for details.
