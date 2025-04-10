// Counts the number of cancelled and non-cancelled flights
void countCancelledFlights() {
  for (Flight flight : flights) {
    if (flight.cancelled) {
      cancelledCount++;
    } else {
      notCancelledCount++;
    }
  }
}

// Draws a bar chart comparing cancelled vs non-cancelled flights
void drawBarChart() {
  int margin = 100;
  int chartHeight = height - 2 * margin;
  int barWidth = (width - 2 * margin) / 2;
  int maxCount = max(cancelledCount, notCancelledCount);  // Scaling

  // Draw chart axes
  stroke(0);
  line(margin, margin, margin, height - margin);  // y-axis
  line(margin, height - margin, width - margin, height - margin);  // x-axis

  // Draw non-cancelled flights bar (left bar)
  fill(204, 204, 255, 130);
  stroke(204, 204, 255, 250);
  notCancelledHeight = map(notCancelledCount, 0, maxCount, 0, chartHeight);  // Scale height
  rect(margin, height - margin - notCancelledHeight, barWidth, notCancelledHeight);

  // Draw cancelled flights bar (right bar)
  fill(50, 160, 255, 130);
  stroke(0, 80, 220, 250);
  cancelledHeight = map(cancelledCount, 0, maxCount, 0, chartHeight);  // Scale height
  rect(margin + barWidth + 20, height - margin - cancelledHeight, barWidth, cancelledHeight);

  // Add chart labels and values
  fill(255, 245, 220);  // Off-white text color
  textAlign(CENTER);
  textFont(flightInfoFont);
  stroke(255);
  textSize(15.1);

  // Bar labels below x-axis
  text("Delayed/Cancelled", margin + barWidth / 2, height - margin + 30);
  text("Cancelled", margin + barWidth + 20 + barWidth / 2, height - margin + 30);

  // Value labels above bars
  text("Total: " + notCancelledCount, margin + barWidth / 2, height - margin - notCancelledHeight - 10);
  text("Total: " + cancelledCount, margin + barWidth + 20 + barWidth / 2, height - margin - cancelledHeight - 10);
}

// Handles click events on the bar chart bars
void onBarClick(boolean isCancelled) {
  flightsForDate.clear(); // Clear all previous results

  // Filter flights
  for (Flight dp : flights) {
    if ((isCancelled && dp.cancelled) || (!isCancelled && !dp.cancelled)) {
      flightsForDate.add(dp); // Add matching flight to list
    }
  }

  // Switch to flights detail screen
  currentScreen = canDelFlights;
  scrollOffset = 0;  // Reset scroll position
}
