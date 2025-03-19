import processing.data.Table;

void setup() {
  // Set the size of the canvas
  size(800, 400);
  
  // Load the CSV file into a Table object
  Table table = loadTable("flights_full.csv", "header");

  if (table == null) {
    println("Error loading file.");
    return;  // Exit setup() if the file isn't loaded
  }

  // Create an array to store the count of flights for each day of the month
  int[] flightsPerDay = new int[31]; // Assuming a maximum of 31 days in a month

  // Iterate through each row of the table
  for (int i = 0; i < table.getRowCount(); i++) {
    // Get the date string from the first column (index 0)
    String dateTime = table.getString(i, 0);

    // Check if dateTime is not empty
    if (dateTime.length() > 0) {
      // Split the date and time using space as delimiter
      String[] dateParts = split(dateTime, ' ');

      // Split the date part (MM/DD/YYYY) by the slash
      String[] dateComponents = split(dateParts[0], '/'); // MM/DD/YYYY

      // Extract the day part (index 1 in the array, which is "DD")
      String dayString = dateComponents[1];  // Get "DD"
      int day = int(dayString);  // Convert the day string to an integer

      // Increment the count for that day if it's valid
      if (day >= 1 && day <= 31) {
        flightsPerDay[day - 1]++; // Subtract 1 because array indices start at 0
      }
    }
  }

  // Draw the Bar Chart
  drawBarChart(flightsPerDay);
}

void draw() {
  // No need to update the drawing continuously
}

void drawBarChart(int[] flightsPerDay) {
  // Set up chart parameters
  int barWidth = width / 31;  // Width of each bar
  int margin = 50;            // Space between chart and edges of canvas
  int chartHeight = height - 2 * margin; // Height of the chart
  
  // Draw the Y Axis (Number of flights)
  stroke(0);
  line(margin, margin, margin, height - margin);
  
  // Draw the X Axis (Days of the month)
  line(margin, height - margin, width - margin, height - margin);
  
  // Draw the bars for each day
  for (int i = 0; i < flightsPerDay.length; i++) {
    // Calculate the height of the bar based on the number of flights
    float barHeight = map(flightsPerDay[i], 0, max(flightsPerDay), 0, chartHeight);
    
    // Draw the bar
    fill(100, 150, 255);  // Set the color for the bars
    rect(margin + i * barWidth, height - margin - barHeight, barWidth - 2, barHeight);
    
    // Draw labels for each day (on x-axis)
    fill(0);
    textSize(10);
    textAlign(CENTER);
    text(i + 1, margin + i * barWidth + barWidth / 2, height - margin + 15);  // Day number
    
    // Draw the flight count label on top of the bar
    if (flightsPerDay[i] > 0) {
      text(flightsPerDay[i], margin + i * barWidth + barWidth / 2, height - margin - barHeight - 5); // Flight count
    }
  }
}
