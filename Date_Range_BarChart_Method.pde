// Draws title for monthly flights chart
void drawChartTitle() {
  textAlign(CENTER);
  textSize(18);
  textFont(flightInfoFont);
  text("Number of Flights per Day", width / 2, margin / 2); // Position title at top center
}

// Creates bar chart showing flight volume by day of month
void drawBarChartForMonthlyFlights() {
  // Calculate Dimensions
  int barWidth = (width - 2 * margin) / 31;
  int chartHeight = height - 2 * margin - 50;

  // Draw axes
  stroke(0);
  line(margin, margin + 50, margin, height - margin); // y-axis
  line(margin, height - margin, width - margin, height - margin); // x-axis

  // Find maximum flights count for scaling (avoid division by zero)
  int maxFlights = max(flightsPerDay);
  if (maxFlights == 0) maxFlights = 1;

  // Draw 31 bars (one per day)
  for (int i = 0; i < 31; i++) {
    float barHeight = map(flightsPerDay[i], 0, maxFlights, 0, chartHeight);

    // Highlight selected day in orange
    fill(i == selectedDay ? color(255, 190, 40, 160) : color(150, 150, 150, 220));
    rect(margin + i * barWidth, height - margin - barHeight, barWidth, barHeight);

    // Label each bar with day number
    fill(0);
    text(i + 1, margin + i * barWidth + barWidth / 2, height - margin + 20);
  }
}

// Shows flights for specific day when bar is clicked
void onBarClickForDaily(int day) {
  selectedDay = day - 1;  // Convert to array index
  dailyFlights.clear();

  // Find all flights for selected day
  for (Flight f : flightsForDate) {
    String[] dateParts = split(f.flightDate, '/');

    // Safety check for valid date format
    if (dateParts.length >= 2 && int(dateParts[1]) == day) {
      dailyFlights.add(f);
    }
  }

  currentScreen = dailyFlightsInfo;
  scrollOffset = 0;
}
