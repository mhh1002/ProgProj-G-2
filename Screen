class MainScreen {
  String label1, label2, label3, label4;
  int event;
  ArrayList<Widget> widgets = new ArrayList<Widget>();
  color backgroundColor;
  color widgetColor;
  PImage bgImage;

  MainScreen(String label1, String label2, String label3, String label4,
    color widgetColor, color backgroundColor, PImage bgImage) {
    this.label1 = label1;
    this.label2 = label2;
    this.label3 = label3;
    this.label4 = label4;
    this.widgetColor = widgetColor;
    this.backgroundColor = backgroundColor;
    this.bgImage = bgImage;
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
    widgets.add (new Widget(475, 260, 350, 40, label1,
      widgetColor, labelFont, DATE_RANGE));
    widgets.add (new Widget(475, 325, 350, 40, label2,
      widgetColor, labelFont, ORIGIN_CITY));
    widgets.add (new Widget(475, 395, 350, 40, label3,
      widgetColor, labelFont, ARRIVAL_CITY));
    widgets.add (new Widget(475, 465, 350, 40, label4,
      widgetColor, labelFont, CAN_DEL_LAT));
  }


  void draw(color mouseHoverColor) {
    background(backgroundColor);
    image(bgImage, 0, 0, 1300, 750);
    fill(0);
    textFont(labelFont);
    textAlign(LEFT, BASELINE);
    text("Search by:", 475, 225);
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
  boolean isCitySearchScreen;
  PImage bgImage;
  Widget backButton = new Widget(1200, 20, 68, 40, "back", labelColor, labelFont, BACK);
  Widget sortAscBtn, sortDescBtn, sortAzBtn, sortZaBtn;


  Screen(String screenName, int Xpos, float Ypos,
    color labelColor, color backgroundColor, int maxScroll,
    boolean isCitySearch, PImage bgImage) {
    this.screenName = screenName;
    this.Xpos = Xpos;
    this.Ypos = Ypos;
    this.labelColor = labelColor;
    this.backgroundColor = backgroundColor;
    this.scrollY = 0;
    this.maxScroll = maxScroll;
    this.bgImage = bgImage;

    this.isCitySearchScreen = isCitySearch;
    this.sortAscBtn = new Widget(1000, 120, 120, 30, "Date ASC",
      color(200), labelFont, SORT_ASC);
    this.sortDescBtn = new Widget(1130, 120, 120, 30, "Date DESC",
      color(200), labelFont, SORT_DESC);
    this.sortAzBtn = new Widget(1000, 160, 120, 30, "",
      color(200), labelFont, SORT_AZ);
    this.sortZaBtn = new Widget(1130, 160, 120, 30, "",
      color(200), labelFont, SORT_ZA);
  }


  void drawScreenName() {
    fill(0);
    textFont(stdFont);
    textAlign(LEFT, TOP);
    text(screenName, Xpos, Ypos); // Draw the screen name considering the scrollY for vertical positioning
  }
  int getSortEvent(int mX, int mY) {
    if (!isCitySearchScreen) return EVENT_NULL;
    int event;
    //
    if ((event = sortAscBtn.getEvent(mX, mY)) != EVENT_NULL) return event;
    if ((event = sortDescBtn.getEvent(mX, mY)) != EVENT_NULL) return event;
    //
    if ((event = sortAzBtn.getEvent(mX, mY)) != EVENT_NULL) return event;
    if ((event = sortZaBtn.getEvent(mX, mY)) != EVENT_NULL) return event;
    return EVENT_NULL;
  }

  void draw(color mouseHoverColor) {
    background(backgroundColor);
    image(bgImage, 0, 0, 1300, 750);
    drawScreenName();
    if (isCitySearchScreen) {
      String cityType = searchByOrigin ? "Dest" : "Origin";
      sortAzBtn.label = cityType + " A-Z";
      sortZaBtn.label = cityType + " Z-A";
      sortAscBtn.draw();
      sortAscBtn.changeColor(mouseX, mouseY, mouseHoverColor);
      sortDescBtn.draw();
      sortDescBtn.changeColor(mouseX, mouseY, mouseHoverColor);
      sortAzBtn.draw();
      sortAzBtn.changeColor(mouseX, mouseY, mouseHoverColor);
      sortZaBtn.draw();
      sortZaBtn.changeColor(mouseX, mouseY, mouseHoverColor);
    }

    backButton.draw();
    backButton.changeColor(mouseX, mouseY, mouseHoverColor);

    if (!mainScreenOn && currentScreen.backButton != null) {
      backButton.draw();
      backButton.changeColor(mouseX, mouseY, mouseHoverColor);
    }
  }
}
