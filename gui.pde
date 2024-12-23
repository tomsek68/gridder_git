void handleGui() {
  // Grid konfigurációk
  cols = gui.sliderInt("Config/Grid Columns", cols, 4, 100);
  rows = gui.sliderInt("Config/Grid Rows", rows, 4, 50);
  maxRecentColors = gui.sliderInt("Config/Max Recent Colors", maxRecentColors, 1, 16);

  // Toolbox kapcsolók
  eyedropperEnabled = gui.toggle("Toolbox/Eyedropper", eyedropperEnabled);
  showPreviousFrame = gui.toggle("Frames/Show Previous", showPreviousFrame);
  showNextFrame = gui.toggle("Frames/Show Next", showNextFrame);
  drawOnlyIfDifferent = gui.toggle("Frames/Draw Only If Different", drawOnlyIfDifferent);

  // Grid méret frissítése szükség esetén
  resizeGridIfNeeded();

  // Színválasztó kezelés
  selectedCol = gui.colorPicker("Toolbox/Color Picker", selectedCol).hex;

  // Frame vezérlők
  handleFrameControls();

  // Korábbi színek megjelenítése
  handleRecentColorsGui();

  // Undo és Redo gombok
  if (gui.button("Frames/Undo")) undo();
  if (gui.button("Frames/Redo")) redo();
}


void handleRecentColorsGui() {
  gui.text("Toolbox/Recent Colors/Text", "Click a recent color to select it:");
  for (int i = 0; i < recentColors.size(); i++) {
    int colOption = recentColors.get(i);

    // Frissítsük a colorPicker színeit a recent listában
    gui.colorPickerSet("Toolbox/Recent Colors/Color Picker " + i, colOption);

    // Megjelenítjük a színeket, és gombként használjuk őket
    int pickedColor = gui.colorPicker("Toolbox/Recent Colors/Color Picker " + i, colOption).hex;

    // Ha a felhasználó rákattint, állítsuk be az aktuális színt
    if (gui.button("Toolbox/Recent Colors/Select " + i)) {
      selectedCol = pickedColor; // Az aktuális szín változik
      gui.colorPickerSet("Toolbox/Color Picker", pickedColor); // Frissítjük az eredeti színválasztót
    }
  }
}
