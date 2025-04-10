// Import necessary libraries
import java.util.*;
import processing.data.Table;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;

// Declare fonts, images, and constants
PFont stdFont;
PFont labelFont;
PFont flightInfoFont;
PImage planeIcon;
PImage bgImage;

// Constants for screen types
final int DATE_RANGE = 1;
final int ORIGIN_CITY = 2;
final int ARRIVAL_CITY = 3;
final int CAN_DEL_LAT = 4;
final int BACK = 5;
final int CAN_DEL_DETAILS = 6;
final int DAILY_FLIGHTS_DATA = 7;
final int EVENT_NULL = 0;
final int GAP = 15;

// Constants for sorting options
final int SORT_ASC = 7;
final int SORT_DESC = 8;
final int SORT_AZ = 9;
final int SORT_ZA = 10;
final int SORT_TYPE_DATE = 0;
final int SORT_TYPE_CITY = 1;

// Layout and positioning constants
final int initial_y2 = 220;
final int initial_y = 135;
final int initial_x = 55;
int scrollOffset = 0;
int rowHeight = 33;
int selectedBarIndex = -1;

// Flight status counters
int cancelledCount = 0; // Count for cancelled (1)
int notCancelledCount = 0; // Count for not cancelled (0)
float notCancelledHeight;
float cancelledHeight;

// Screen state flags
boolean showFlightScreen = false; // Switch between bar chart and flight details screen
String selectedDate = "";

// Charting variables
int margin = 50;
int[] flightsPerDay = new int[31];
int flightDay;
int day = 0;
String flightInfo;
ArrayList<String> flightData = new ArrayList<>();
int selectedDay = -1;
ArrayList<Flight> dailyFlights = new ArrayList<>();

// Sorting flags
boolean sortAscending = true;    // For date sorting
boolean currentSortAZ = true;    // For alphabetical sorting
int currentSortType = -1;        // Current sort type

// UI state flags
boolean mainScreenOn = true;
boolean showFlights = false;
String searchQuery = "";
boolean searchByOrigin = false;
boolean searchByArrival = false;
boolean inputError = false;

// Data collections
ArrayList<Flight> flights = new ArrayList<>();
ArrayList<Flight> flightsForDate;
ArrayList<Flight> filteredFlights = new ArrayList<>();

// UI components
Widget widget1, widget2, widget3, widget4;
MainScreen myMainScreen;
Screen monthlyFlightScr, originCityScr, arrivalCityScr, canDelLatScr, canDelFlights, dailyFlightsInfo;
Screen currentScreen;
color event_Color;

// Search button dimensions
int searchButtonX = 280;
int searchButtonY = 120;
int searchButtonW = 80;
int searchButtonH = 40;

void setup() {
  size(1300, 750);

  // Load images and fonts
  planeIcon = loadImage("planeIcon.png");
  bgImage = loadImage("planephoto1.jpg");

  color labelColor = color(0, 10, 97);
  stdFont = loadFont("AlNile-40.vlw");
  labelFont = loadFont("FZLTXHB--B51-0-20.vlw");
  flightInfoFont = createFont("Arial", 15);

  // Initialize flight data collections
  flightsForDate = new ArrayList<Flight>();

  // Read flight data from CSV
  readData("flights_full.csv");

  // Initialize screens
  myMainScreen = new MainScreen("Monthly flights", "Origin city",
    "Arrival city", "Cancelled/Delayed/Late flights", labelColor, 230, bgImage);

  monthlyFlightScr = new Screen("Monthly Flights Search", 30, 55, labelColor, 230, -1600, false, bgImage);
  originCityScr = new Screen("Origin City Search", 30, 55, labelColor, 230, -9000, true, bgImage);
  arrivalCityScr = new Screen("Arrival City Search", 30, 55, labelColor, 230, -9000, true, bgImage);
  canDelLatScr = new Screen("Cancelled/Delayed/Late Flights Search", 30, 25, labelColor, 230, 0, false, bgImage);
  canDelFlights = new Screen("Cancelled/ Delayed Flights Information", 9, 25, labelColor, 230, -9000, false, bgImage);
  dailyFlightsInfo = new Screen("Flight Details for Day ", 9, 25, labelColor, 230, -9000, false, bgImage);
  mainScreenOn = true;

  // Count cancelled flights for statistics
  countCancelledFlights();
}

void draw() {
  // Draw appropriate screen based on current state
  if (!mainScreenOn) {
    if (currentScreen != null) {
      currentScreen.draw(color(0, 41, 224));
    }

    // Handle different screen types
    if (currentScreen == originCityScr || currentScreen == arrivalCityScr) {
      drawSearchBox();
      drawSearchButton();
      displayFilteredFlights();

      if (inputError) {
        displayWarning();
      }
    } else if (currentScreen == canDelLatScr) {
      currentScreen.scrollY = 0;
      drawBarChart();
    } else if (currentScreen == canDelFlights) {
      displayFlights();
    } else if (currentScreen == monthlyFlightScr) {
      drawChartTitle();
      drawBarChartForMonthlyFlights();
    } else if (currentScreen == dailyFlightsInfo) {
      drawFlightInfoScreen();
    }
  } else {
    myMainScreen.draw(color(0, 41, 224));
  }
}

void displayFlights() {
  // Flight list container (unchanged)
  fill(253, 211, 219, 155);
  stroke(255, 87, 51, 90);
  rect(50, 100, width - 130, height - 150, 17);

  // Draw headers
  fill(0);
  textFont(flightInfoFont);
  textSize(20);
  String headers = "Date, Time, Flight Number, Origin, Destination, Real-Time dep/arr time and Distance are as followed:";
  text(headers, 55, 81.3);

  // Draw flight information
  fill(40, 30, 50, 260);
  textFont(flightInfoFont);
  textSize(16); // Remodify text size

  int y = initial_y - currentScreen.scrollY; // intial y position

  // Display each flight in the list
  for (int i = 0; i < flightsForDate.size(); i++) {
    Flight dp = flightsForDate.get(i);

    // Only draw visible flights
    if (y > 125 && y < height - 48) {
      String flightInfo = dp.getDisplayString();
      textAlign(LEFT);
      text(flightInfo, initial_x, y); // Display flight details
    }

    y += rowHeight; // Move down for next query
  }
}

void drawSearchBox() {
  // Draw search box background
  fill(255);
  rect(30, 120, 240, 40); // Apply currentScreen.scrollY to search box Y position
  fill(0);
  textSize(15);

  // Show placeholder text if search query is empty
  if (searchQuery.isEmpty()) {
    fill(150);
    text("Enter city full name to search", 40, 135); // Apply currentScreen.scrollY to text position
  } else {
    fill(0);
    text(searchQuery, 40, 135); // Apply currentScreen.scrollY to text position
  }
}

void drawSearchButton() {
  // Handle button hover state
  fill(color(0, 10, 97));

  if (mouseX > searchButtonX && mouseX < searchButtonX + searchButtonW && mouseY > searchButtonY
    && mouseY < searchButtonY + searchButtonH) {
    fill(color(0, 41, 224));
    rect(searchButtonX, searchButtonY, searchButtonW, searchButtonH, 10); // Apply currentScreen.scrollY to button position
    fill(255);
    textSize(16);
    text("Search", searchButtonX + 15, searchButtonY + 15);// Apply currentScreen.scrollY to text position
  } else {
    fill(color(0, 10, 97));
    rect(searchButtonX, searchButtonY, searchButtonW, searchButtonH, 10); // Apply currentScreen.scrollY to button position
    fill(255);
    textSize(16);
    text("Search", searchButtonX + 15, searchButtonY + 15);// Apply currentScreen.scrollY to text position
  }
}

void displayFilteredFlights() {
  // Set up text styling for flight display
  fill(100, 93, 170);
  textFont(flightInfoFont);
  textSize(14.8);
  textAlign(LEFT, 60);

  // Calculate positions for flight cards
  int centerX = (width - 550) / 2 - 8;
  int centerBox = centerX + 225;
  int y = initial_y2 - currentScreen.scrollY;

  // Display total flights count
  text("Total Flights: " + filteredFlights.size(), 30, 190);

  // Display each filtered flight
  for (int i = 0; i < filteredFlights.size(); i++) {
    Flight flight = filteredFlights.get(i);

    int boxX = centerX;
    int boxY = y;
    int boxWidth = 630;
    int boxHeight = 100;

    // Only Draw flights within the size of Screen
    if (boxY + boxHeight < 0 || boxY > height) {
      y += boxHeight + 10;
      continue;
    }

    // Set color based on flight status
    if (flight.cancelled) {
      fill(#934C4C, 220);
    } else if (flight.diverted) {
      fill(#E08A09, 220);
    } else {
      fill(#7CD1E8, 220);
    }

    // Draw flight card background
    stroke(0);
    rect(boxX, boxY, boxWidth, boxHeight, 10);

    // Draw flight information
    fill(0);
    textSize(16);
    text(flight.flightNumber, boxX + 50, boxY + 20);
    text(flight.fromattedDate, boxX + 350, boxY + 20);

    textSize(20);
    text(flight.originCity, boxX + 35, boxY + 60);
    text(flight.formattedDepTime, boxX + 60, boxY + 85);

    text(flight.destCity, boxX + 320, boxY + 60);
    text(flight.formattedArrTime, boxX + 350, boxY + 85);

    // Draw plane icon and distance
    image(planeIcon, centerBox + 20, boxY + 38, 30, 30);
    textSize(18);
    text(flight.distance + " km", centerBox, boxY + 83);

    // Display flight status
    fill(255);
    textSize(18);
    if (!flight.cancelled && !flight.diverted) {
      text(" on time ", centerBox, boxY + 20);
    } else if (flight.cancelled) {
      text(" cancelled ", centerBox, boxY + 20);
    } else {
      text(" diverted ", centerBox, boxY + 20);
    }

    y += boxHeight + 10;
  }
}

void displayWarning() {
  // Display input error message
  fill(255, 0, 0);
  textSize(20);
  text("Invalid input. Try Again, please enter a valid city full name only.", 30, 220 + currentScreen.scrollY); // Apply currentScreen.scrollY to warning
}

void keyPressed() {
  // Handle keyboard input for search
  if (key == BACKSPACE && searchQuery.length() > 0) {
    searchQuery = searchQuery.substring(0, searchQuery.length() - 1);
  } else if (key == ENTER) {
    searchFlights();
    printUserInput();
  } else if (key != CODED) {
    searchQuery += key;
  }
}

void resetSearch() {
  // Reset search state
  searchQuery = "";
  searchByOrigin = false;
  searchByArrival = false;
  showFlights = false;
  filteredFlights.clear();
  inputError = false;
}

void printUserInput() {
  // Debug print for user input
  println("User input: " + searchQuery);
}
