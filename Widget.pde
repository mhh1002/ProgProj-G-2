class Widget {
  // Widget properties
  int x, y, width, height;
  String label;
  int event;
  color widgetColor, labelColor, mouseHoverColor, defaultColor;
  PFont widgetFont;

  // Constructor
  Widget(int x, int y, int width, int height, String label,
    color widgetColor, PFont widgetFont, int event) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.label = label;
    this.event = event;
    this.widgetColor = widgetColor;
    this.defaultColor = widgetColor; // Store original color
    this.widgetFont = widgetFont;
    labelColor = color(0); // Default text color (black)
  }

  // Draw widget on screen
  void draw() {
    pushStyle();
    stroke(0, 10, 97);
    fill(widgetColor); // Background color
    rect(x, y, width, height); // Draw button rectangle

    // Draw label text
    fill(255); // White
    textFont(widgetFont);
    textSize(19);
    textAlign(LEFT, BASELINE);
    float textHeight = textAscent() + textDescent();
    float textY = y + height / 2 + textHeight / 2 - textDescent();
    text(label, x + GAP, textY); // Position text with GAP padding

    popStyle();
  }


  // Changes color when mouse hovers over widget
  void changeColor(int mX, int mY, color mouseHoverColor) {
    this.mouseHoverColor = mouseHoverColor;
    if (mX > x && mX < x + width && mY > y && mY < y + height)
      widgetColor = mouseHoverColor; // Hover state
    else
      widgetColor = defaultColor; // Normal state
  }

  // Checks if widget was clicked and returns its event code
  int getEvent(int mX, int mY) {
    if (mX > x && mX < x + width && mY > y && mY < y + height) {
      return event; // Return widget's event code
    }
    return EVENT_NULL; // No interaction
  }
}
