int[][] createEmptyFrame() {
  int[][] newFrame = new int[cols][rows];
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      newFrame[x][y] = defaultGridColor; // Használja a globális alapértelmezett színt
    }
  }
  return newFrame;
}

int[][] copyFrame(int[][] frame) {
  int[][] copy = new int[cols][rows];
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      copy[x][y] = frame[x][y];
    }
  }
  return copy;
}

int getComplementaryGrayscale(int col) {
  return 255 - (int)(red(col) * 0.3 + green(col) * 0.59 + blue(col) * 0.11);
}

void addToRecentColors(int col) {
  if (!recentColors.contains(col)) {
    recentColors.add(col);
    if (recentColors.size() > maxRecentColors) {
      recentColors.remove(0); // Legrégebbi szín eltávolítása
    }
  }
}

void handleEyedropper() {
  if (!eyedropperEnabled) return; // Csak akkor működik, ha a pipetta engedélyezve van

  int x = mouseX / cellSize;
  int y = mouseY / cellSize;

  if (x >= 0 && x < cols && y >= 0 && y < rows) {
    int pickedColor = frames.get(currentFrame)[x][y]; // Kiválasztott szín az aktuális rácsból
    gui.colorPickerSet("Toolbox/Color Picker", pickedColor); // Frissítjük a GUI színválasztót
    selectedCol = pickedColor; // Beállítjuk az aktuális színt
    addToRecentColors(pickedColor); // Hozzáadjuk a korábbi színekhez
  }
}
