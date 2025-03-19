import processing.data.Table;

int cancelledCount = 0; // Count for cancelled (1)
int notCancelledCount = 0; // Count for not cancelled (0)

void setup() {
  // Load the CSV file into a Table object
  Table table = loadTable("flights_full.csv", "header");

  if (table == null) {
    println("Error loading file.");
    return;  // Exit if file isn't loaded
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

  // Print the results
  println("Total not cancelled flights (0): " + notCancelledCount);
  println("Total cancelled flights (1): " + cancelledCount);
}

void draw() {
  // No need for draw() in this example
}
