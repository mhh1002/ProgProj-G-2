void drawFlightInfoScreen() {
  // Draw flight list container with rounded corners
  fill(253, 211, 219, 140);
  stroke(255, 87, 51, 90);
  rect(50, 100, width - 230, height - 150, 10);  // Main container rectangle

  // Calculate scrolling parameters
  int itemsPerPage = floor((height - 170) / rowHeight);  // Visible rows
  int maxScroll = max(0, flightData.size() * rowHeight - (height - 170));
  currentScreen.scrollY = constrain(currentScreen.scrollY, 0, maxScroll);  // Limit scroll range

  // Set text style for flight details
  fill(40, 30, 50, 260);
  textSize(12);
  textAlign(LEFT);

  // Draw fixed column headers
  fill(0);
  textFont(flightInfoFont);
  textSize(20);
  text("Date, Time, Flight Number, Origin, Destination, Distance are as followed:", 70, 93.5);

  // Render visible flight data with scroll offset
  textSize(15);
  int startIndex = floor(currentScreen.scrollY / rowHeight);  // First visible item
  int yPos = 145;  // Vertical start position below headers

  // Only draw visible items for performance
  for (int i = startIndex; i < min(startIndex + itemsPerPage, flightData.size()); i++) {
    String flight = flightData.get(i);
    float drawY = yPos + (i - startIndex) * rowHeight - (currentScreen.scrollY % rowHeight);
    text(flight, 70, drawY);  // Draw each flight line
  }
}
