void countCancelledFlights() {
  for (Flight flight : flights) {
    if (flight.cancelled) {
      cancelledCount++;
    } else {
      notCancelledCount++;
    }
  }
}


void drawBarChart() {
  int margin = 100;
  int chartHeight = height - 2 * margin;
  int barWidth = (width - 2 * margin) / 2;
  int maxCount = max(cancelledCount, notCancelledCount);

  stroke(0);
  line(margin, margin, margin, height - margin);
  line(margin, height - margin, width - margin, height - margin);

  fill(204, 204, 255, 130);  // color
  stroke(204, 204, 255, 250);   // stroke
  notCancelledHeight = map(notCancelledCount, 0, maxCount, 0, chartHeight);
  rect(margin, height - margin - notCancelledHeight, barWidth, notCancelledHeight);

  fill(50, 160, 255, 130);  // color
  stroke(0, 80, 220, 250);   // stroke
  cancelledHeight = map(cancelledCount, 0, maxCount, 0, chartHeight);
  rect(margin + barWidth + 20, height - margin - cancelledHeight, barWidth, cancelledHeight);

  fill(255, 245, 220);
  textAlign(CENTER);
  textFont(flightInfoFont);
  stroke(255);
  textSize(15.1);
  text("Delayed/Cancelled", margin + barWidth / 2, height - margin + 30);
  text("Cancelled", margin + barWidth + 20 + barWidth / 2, height - margin + 30);
  text("Total: " + notCancelledCount, margin + barWidth / 2, height - margin - notCancelledHeight - 10);
  text("Total: " + cancelledCount, margin + barWidth + 20 + barWidth / 2, height - margin - cancelledHeight - 10);
}


void onBarClick(boolean isCancelled) {
  flightsForDate.clear(); // Clear all previous results
  for (Flight dp : flights) {
    if ((isCancelled && dp.cancelled) || (!isCancelled && !dp.cancelled)) { // Match flight date to selected date
      flightsForDate.add(dp); // Add flight to List
    }
  }

  currentScreen = canDelFlights;
  scrollOffset = 0;
}
