void drawCurrentFrame() {
  int[][] grid = frames.get(currentFrame); // Aktuális képkocka
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      fill(grid[x][y]);
      stroke(gridLineColor); // Grid vonalak színe a globális változóból
      rect(x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }
}

void drawPreviousAndNextFrames() {
  int[][] grid = frames.get(currentFrame); // Aktuális képkocka

  // Előző képkocka megjelenítése
  if (showPreviousFrame && currentFrame > 0) {
    int[][] prevGrid = frames.get(currentFrame - 1);
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        if (!drawOnlyIfDifferent || grid[x][y] != prevGrid[x][y]) {
          int pixelColor = prevGrid[x][y];
          fill(pixelColor);
          noStroke();
          ellipse(x * cellSize + cellSize * 0.25f, y * cellSize + cellSize * 0.75f, cellSize / 4, cellSize / 4);
        }
      }
    }
  }

  // Következő képkocka megjelenítése
  if (showNextFrame && currentFrame < frames.size() - 1) {
    int[][] nextGrid = frames.get(currentFrame + 1);
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        if (!drawOnlyIfDifferent || grid[x][y] != nextGrid[x][y]) {
          int pixelColor = nextGrid[x][y];
          fill(pixelColor);
          noStroke();
          ellipse(x * cellSize + cellSize * 0.75f, y * cellSize + cellSize * 0.25f, cellSize / 4, cellSize / 4);
        }
      }
    }
  }
}

void handleDrawing() {
  int x = mouseX / cellSize; 
  int y = mouseY / cellSize;

  // Ellenőrizd, hogy az egér a rács területén belül van-e
  if (x >= 0 && x < cols && y >= 0 && y < rows) {
    // Mentés a history-ba, ha még nincs mentve
    if (historyBuffers.get(currentFrame).isEmpty() || !historyBuffers.get(currentFrame).peekLast().equals(frames.get(currentFrame))) {
      saveStateToHistory();
    }

    // Rajzolás az aktuális képkockára
    frames.get(currentFrame)[x][y] = selectedCol;

    // Redo buffer kiürítése, mivel új művelet történt
    redoBuffers.get(currentFrame).clear();
  }
}

void saveStateToHistory() {
  // Másolat készítése a jelenlegi állapotról
  int[][] frameCopy = copyFrame(frames.get(currentFrame));
  historyBuffers.get(currentFrame).addLast(frameCopy);

  // Túlcsordulás esetén töröljük a legrégebbi állapotot
  if (historyBuffers.get(currentFrame).size() > maxHistorySize) {
    historyBuffers.get(currentFrame).removeFirst();
  }
}

void undo() {
  if (!historyBuffers.get(currentFrame).isEmpty()) {
    // Másolat az aktuális állapotról, és mentés a redo-ba
    int[][] currentCopy = copyFrame(frames.get(currentFrame));
    redoBuffers.get(currentFrame).addLast(currentCopy);

    // Visszaállítás a history-ból
    frames.set(currentFrame, historyBuffers.get(currentFrame).removeLast());
  }
}

void redo() {
  if (!redoBuffers.get(currentFrame).isEmpty()) {
    // Másolat az aktuális állapotról, és mentés a history-ba
    saveStateToHistory();

    // Visszaállítás a redo-ból
    frames.set(currentFrame, redoBuffers.get(currentFrame).removeLast());
  }
}
