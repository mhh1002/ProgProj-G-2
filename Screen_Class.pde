class MainScreen {
  String label1, label2, label3, label4;
  int event;
  ArrayList<Widget> widgets = new ArrayList<Widget>();
  color backgroundColor;
  color widgetColor;

  MainScreen(String label1, String label2, String label3, String label4,
    color widgetColor, color backgroundColor) {
    this.label1 = label1;
    this.label2 = label2;
    this.label3 = label3;
    this.label4 = label4;
    this.widgetColor = widgetColor;
    this.backgroundColor = backgroundColor;
    this.addWidget();
  }


   int getEvent(int mX, int mY) {
    for (Widget w : widgets) {
      event = w.getEvent(mX, mY);
      if (event != EVENT_NULL) {
        return event;
      }
    }

    return EVENT_NULL;
  }


  void addWidget() {
    widgets.add (new Widget(380, 230, 350, 40, label1,
      widgetColor, labelFont, DATE_RANGE));
    widgets.add (new Widget(380, 300, 350, 40, label2,
      widgetColor, labelFont, ORIGIN_CITY));
    widgets.add (new Widget(380, 370, 350, 40, label3,
      widgetColor, labelFont, ARRIVAL_CITY));
    widgets.add (new Widget(380, 440, 350, 40, label4,
      widgetColor, labelFont, CAN_DEL_LAT));
  }
  
  
  void draw(color mouseHoverColor) {
    background(backgroundColor);
    fill(0);
    textFont(labelFont);
    textAlign(LEFT, BASELINE);
    text("Search by:", 380, 200);
    for (Widget w : widgets) {
      w.draw();
      w.changeColor(mouseX, mouseY, mouseHoverColor);
    }
  }
}


class Screen {
  String screenName;
  int Xpos;
  float Ypos;
  color labelColor;
  color backgroundColor;
  int scrollY, maxScroll;
  Widget backButton = new Widget(1200, 20, 68, 40, "back", labelColor, labelFont, BACK);


  Screen(String screenName, int Xpos, float Ypos,
    color labelColor, color backgroundColor, int maxScroll) {
    this.screenName = screenName;
    this.Xpos = Xpos;
    this.Ypos = Ypos;
    this.labelColor = labelColor;
    this.backgroundColor = backgroundColor;
    this.scrollY = 0;
    this.maxScroll = maxScroll;
  }


  void drawScreenName() {
    fill(0);
    textFont(stdFont);
    textAlign(LEFT, TOP);
    text(screenName, Xpos, Ypos); // Draw the screen name considering the scrollY for vertical positioning
  }


  void draw(color mouseHoverColor) {
    background(backgroundColor);

    drawScreenName();

    if (!mainScreenOn && currentScreen.backButton != null) {
      backButton.draw();
      backButton.changeColor(mouseX, mouseY, mouseHoverColor);
    }
  }
}
