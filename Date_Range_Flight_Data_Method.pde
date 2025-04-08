void drawFlightInfoScreen() {
  // Flight list container (unchanged)
  fill(253, 211, 219, 140);
  stroke(255, 87, 51, 90);

  rect(50, 100, width - 230, height - 150, 10);

  // Calculate scroll parameters
  int itemsPerPage = floor((height - 170) / rowHeight); // 170 = top+bottom margins
  int maxScroll = max(0, flightData.size() * rowHeight - (height - 170));
  currentScreen.scrollY = constrain(currentScreen.scrollY, 0, maxScroll);

  // Flight details (unchanged)
  fill(40, 30, 50, 260);
  textSize(12);
  textAlign(LEFT);

  // Column headers (unchanged, always visible)
  fill(0);
  textFont(flightInfoFont);
  textSize(20);
  String headers = "Date, Time, Flight Number, Origin, Destination, Distance are as followed:";
  text(headers, 70, 93.5);

  // Flight data with scroll
  textSize(15);
  int startIndex = floor(currentScreen.scrollY / rowHeight);
  int yPos = 145; // Start below headers

  for (int i = startIndex; i < min(startIndex + itemsPerPage, flightData.size()); i++) {
    String flight = flightData.get(i);
    float drawY = yPos + (i - startIndex) * rowHeight - (currentScreen.scrollY % rowHeight);

    text(flight, 70, drawY);
  }
}
