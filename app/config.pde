// some helpful constants 

// SCREEN SCALES
// helps scale canvas to appear 1:1 on screen
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

// ----------------------------
// ### PROJECT CONFIG ###

// SCREEN SETTINGS 
boolean useRetinaDisplay = true;
boolean fullscreen = true;
float displayScale = MACBOOK_13_SCALE;

// PRINT SETTINGS (in inches)
float printW = 17;
float printH = 14;

// PLOTTER SETTINGS (in inches)
float maxPlotW = 17;
float maxPlotH = 11;
boolean constrainToPlotArea = false;

// pen thickness (in mm)
float penSize = POSCA_3M; 

// save a PNG preview alongside SVG
boolean savePNGPreview = true;