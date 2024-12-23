void handleFrameControls() {
  // Képkocka vezérlők szöveg
  gui.text("Frames/Text", "Frame controls:");

  // Előző képkocka
  if (gui.button("Frames/Previous Frame") && currentFrame > 0) {
    currentFrame--;
  }

  // Következő képkocka
  if (gui.button("Frames/Next Frame") && currentFrame < frames.size() - 1) {
    currentFrame++;
  }

  // Új képkocka hozzáadása
  if (gui.button("Frames/Add Frame")) {
    frames.add(currentFrame + 1, createEmptyFrame());
    historyBuffers.add(new ArrayDeque<>()); // Új history buffer az új képkockához
    redoBuffers.add(new ArrayDeque<>());    // Új redo buffer az új képkockához
    currentFrame++; // Az új képkockára ugrás
  }

  // Képkocka törlése
  if (gui.button("Frames/Delete Frame") && frames.size() > 1) {
    frames.remove(currentFrame);
    historyBuffers.remove(currentFrame); // History buffer eltávolítása
    redoBuffers.remove(currentFrame);    // Redo buffer eltávolítása
    currentFrame = max(0, currentFrame - 1); // Visszaugrás az előző képkockára
  }

  // Aktuális képkocka kijelzése
  gui.textSet("Frames/Current Frame", "Current Frame: " + (currentFrame + 1) + " / " + frames.size());
}

void resizeGridIfNeeded() {
  if (cols != frames.get(0).length || rows != frames.get(0)[0].length) {
    for (int i = 0; i < frames.size(); i++) {
      frames.set(i, resizeFrame(frames.get(i)));
    }
  }
}

int[][] resizeFrame(int[][] frame) {
  int[][] newFrame = new int[cols][rows];
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      if (x < frame.length && y < frame[0].length) {
        newFrame[x][y] = frame[x][y];
      } else {
        newFrame[x][y] = color(255); // Új cellák fehér színnel
      }
    }
  }
  return newFrame;
}
