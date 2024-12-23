import com.krab.lazy.LazyGui;
import java.util.ArrayList;
import java.util.ArrayDeque;
import java.util.Deque;

int cols = 60; // Oszlopok száma
int rows = 25; // Sorok száma
int cellSize; // Egy négyzet mérete (dinamikusan számítva)
ArrayList<int[][]> frames = new ArrayList<>(); // Képkockák listája
int currentFrame = 0; // Aktuális képkocka index
LazyGui gui;
int selectedCol; // Kiválasztott szín (hex érték)
ArrayList<Integer> recentColors = new ArrayList<>(); // Korábbi színek
int maxRecentColors = 8; // Maximum 8 színt tárolhat
boolean eyedropperEnabled = false; // Pipetta kapcsoló
boolean showPreviousFrame = false; // Előző frame megjelenítése
boolean showNextFrame = false; // Következő frame megjelenítése
boolean drawOnlyIfDifferent = false; // Csak akkor rajzol köröket, ha a színek különböznek

int defaultPickerColor = color(127); // Alapértelmezett szín: szürke
int defaultGridColor = color(0);    // Alapértelmezett grid szín: fekete
int backgroundColor = color(0);     // Háttérszín: fekete
int gridLineColor = color(127);     // Rácsvonalak színe: szürke

// Undo/Redo kezelés
ArrayList<Deque<int[][]>> historyBuffers = new ArrayList<>(); // Képkockánként történő undo history
ArrayList<Deque<int[][]>> redoBuffers = new ArrayList<>(); // Képkockánként történő redo history
int maxHistorySize = 3; // Maximum visszavonási lépések száma

void setup() {
  size(1200, 600, P2D); // Ablak mérete
  cellSize = min(width / cols, height / rows); // Dinamikus cellaméret
  gui = new LazyGui(this); // LazyGui inicializálása

  // Kezdő képkocka hozzáadása
  frames.add(createEmptyFrame());
  historyBuffers.add(new ArrayDeque<>()); // History inicializálása az első frame-hez
  redoBuffers.add(new ArrayDeque<>());    // Redo buffer inicializálása
  selectedCol = defaultPickerColor; // Alapértelmezett szín inicializálása
  gui.colorPickerSet("Toolbox/Color Picker", defaultPickerColor); // Color Picker inicializálása
}

void draw() {
  background(backgroundColor); // Háttérszín beállítása

  // Először az aktuális képkockát rajzoljuk ki
  drawCurrentFrame();

  // Majd az előző és következő képkockák színeit
  drawPreviousAndNextFrames();

  // GUI kezelése
  handleGui();

  // LazyGui megjelenítése
  gui.draw();
}

void mousePressed() {
  if (mouseButton == RIGHT && gui.isMouseOutsideGui()) {
    handleEyedropper();
  } else if (mouseButton == LEFT && gui.isMouseOutsideGui()) {
    handleDrawing();
  }
}

void mouseDragged() {
  if (mouseButton == LEFT && gui.isMouseOutsideGui()) {
    handleDrawing();
  }
}
