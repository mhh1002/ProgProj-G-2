import processing.data.Table;

int cancelledCount = 0; // Count for cancelled (1)
int notCancelledCount = 0; // Count for not cancelled (0)

void setup() {
  // Set up the size of the canvas
  size(800, 400);
  
  // Load the CSV file into a Table object
  Table table = loadTable("flights_full.csv", "header");

  if (table == null) {
    println("Error loading file.");
    return;  // Exit if the file isn't loaded
  }

  // Iterate through each row of the table
  for (int i = 0; i < table.getRowCount(); i++) {
    // Access the 16th column (index 15, because arrays are 0-indexed)
    int cancellationStatus = table.getInt(i, 15);

    // Check if the cancellation status is 0 or 1
    if (cancellationStatus == 0) {
      notCancelledCount++; // Increment count for not cancelled (0)
    } else if (cancellationStatus == 1) {
      cancelledCount++; // Increment count for cancelled (1)
    }
  }

  // Draw the Bar Chart based on the counts
  drawBarChart();
}

void draw() {
  // No need to update the drawing continuously
}

void drawBarChart() {
  // Set up chart parameters
  int margin = 100;          // Space between chart and edges of canvas
  int chartHeight = height - 2 * margin; // Height of the chart
  int barWidth = (width - 2 * margin) / 2; // Width of each bar, adjusted to fit the screen
  
  // Find the maximum count to scale the bar heights
  int maxCount = max(cancelledCount, notCancelledCount);
  
  // Draw the Y Axis (Number of flights)
  stroke(0);
  line(margin, margin, margin, height - margin); // Y Axis
  
  // Draw the X Axis (Cancelled / Not Cancelled)
  line(margin, height - margin, width - margin, height - margin); // X Axis
  
  // Draw the bar for not cancelled flights (0)
  fill(0, 255, 0); // Green color for not cancelled
  float notCancelledHeight = map(notCancelledCount, 0, maxCount, 0, chartHeight); // Scale the height
  rect(margin, height - margin - notCancelledHeight, barWidth, notCancelledHeight); 

  // Draw the bar for cancelled flights (1)
  fill(255, 0, 0); // Red color for cancelled
  float cancelledHeight = map(cancelledCount, 0, maxCount, 0, chartHeight); // Scale the height
  rect(margin + barWidth + 20, height - margin - cancelledHeight, barWidth, cancelledHeight); // Add some space between the bars

  // Add text labels for the X Axis (Cancelled/Not Cancelled)
  fill(0);
  textAlign(CENTER);
  textSize(14);
  text("Not Cancelled", margin + barWidth / 2, height - margin + 30);
  text("Cancelled", margin + barWidth + 20 + barWidth / 2, height - margin + 30);

  // Add labels for flight counts
  text("Total: " + notCancelledCount, margin + barWidth / 2, height - margin - notCancelledHeight - 10);
  text("Total: " + cancelledCount, margin + barWidth + 20 + barWidth / 2, height - margin - cancelledHeight - 10);
}
