import java.util.*;
import processing.data.Table;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;

//import com.opencsv.CSVReader;
//import com.opencsv.exceptions.CsvException;
//import java.io.FileReader;
//import java.io.IOException;
//import java.util.List;
//import java.util.HashMap;


PFont stdFont;
PFont labelFont;
PFont flightInfoFont;
PImage planeIcon;
PImage bgImage;
final int DATE_RANGE = 1;
final int ORIGIN_CITY = 2;
final int ARRIVAL_CITY = 3;
final int CAN_DEL_LAT = 4;
final int BACK = 5;
final int CAN_DEL_DETAILS = 6;
final int DAILY_FLIGHTS_DATA = 7;
final int EVENT_NULL = 0;
final int GAP = 15;

final int SORT_ASC = 7;
final int SORT_DESC = 8;
final int SORT_AZ = 9;
final int SORT_ZA = 10;
final int SORT_TYPE_DATE = 0;
final int SORT_TYPE_CITY = 1;

final int initial_y2 = 220;
final int initial_y = 120;
final int initial_x = 55;
int scrollOffset = 0;
int rowHeight = 20;
int selectedBarIndex = -1;
int cancelledCount = 0; // Count for cancelled (1)
int notCancelledCount = 0; // Count for not cancelled (0)
float notCancelledHeight;
float cancelledHeight;
boolean showFlightScreen = false; // Switch between bar chart and flight details screen
String selectedDate = "";

int margin = 50;
int[] flightsPerDay = new int[31];
int flightDay;
int day = 0;
String flightInfo;
ArrayList<String> flightData = new ArrayList<>();
int selectedDay = -1;
ArrayList<Flight> dailyFlights = new ArrayList<>();

boolean sortAscending = true;    //
boolean currentSortAZ = true;    //
int currentSortType = -1;

boolean mainScreenOn = true;
boolean showFlights = false;
String searchQuery = "";
boolean searchByOrigin = false;
boolean searchByArrival = false;
boolean inputError = false;

ArrayList<Flight> flights = new ArrayList<>();
ArrayList<Flight> flightsForDate;
ArrayList<Flight> filteredFlights = new ArrayList<>();

Widget widget1, widget2, widget3, widget4;
MainScreen myMainScreen;
Screen monthlyFlightScr, originCityScr, arrivalCityScr, canDelLatScr, canDelFlights, dailyFlightsInfo;
Screen currentScreen;
color event_Color;

int searchButtonX = 280;
int searchButtonY = 120;
int searchButtonW = 80;
int searchButtonH = 40;


void setup() {
  size(1300, 750);

  planeIcon = loadImage("planeIcon.png");
  bgImage = loadImage("planephoto1.jpg");

  color labelColor = color(0, 10, 97);
  stdFont = loadFont("AlNile-40.vlw");
  labelFont = loadFont("FZLTXHB--B51-0-20.vlw");
  flightInfoFont = createFont("Arial", 15);

  flightsForDate = new ArrayList<Flight>();

  readData("flights_full.csv");

  myMainScreen = new MainScreen("Monthly flights", "Origin city",
    "Arrival city", "Cancelled/Delayed/Late flights", labelColor, 230, bgImage);

  monthlyFlightScr = new Screen("Monthly Flights Search", 30, 55, labelColor, 230, -1600, false, bgImage);
  originCityScr = new Screen("Origin City Search", 30, 55, labelColor, 230, -9000, true, bgImage);
  arrivalCityScr = new Screen("Arrival City Search", 30, 55, labelColor, 230, -9000, true, bgImage);
  canDelLatScr = new Screen("Cancelled/Delayed/Late Flights Search", 30, 25, labelColor, 230, 0, false, bgImage);
  canDelFlights = new Screen("Cancelled/ Delayed Flights Information", 9, 25, labelColor, 230, -9000, false, bgImage);
  dailyFlightsInfo = new Screen("Flight Details for Day ", 9, 25, labelColor, 230, -9000, false, bgImage);
  mainScreenOn = true;


  countCancelledFlights();
}


void draw() {
  if (!mainScreenOn) {
    if (currentScreen != null) {
      currentScreen.draw(color(0, 41, 224));
    }

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
  fill(253, 211, 219, 140);
  stroke(255, 87, 51, 90);

  rect(50, 100, width - 230, height - 150, 10);

  fill(40, 30, 50, 260);
  textFont(flightInfoFont);
  textSize(14.8);

  int y = initial_y - currentScreen.scrollY; // intial y position

  for (int i = 0; i < flightsForDate.size(); i++) {
    Flight dp = flightsForDate.get(i);

    if (y > 115 && y < height - 48) {
      String flightInfo = dp.getDisplayString();
      textAlign(LEFT);
      text(flightInfo, initial_x, y); // Display flight details
    }

    y += rowHeight; // Move down for next query
  }
}


void drawSearchBox() {
  fill(255);
  rect(30, 120, 240, 40); // Apply currentScreen.scrollY to search box Y position
  fill(0);
  textSize(15);
  if (searchQuery.isEmpty()) {
    fill(150);
    text("Enter city full name to search", 40, 135); // Apply currentScreen.scrollY to text position
  } else {
    fill(0);
    text(searchQuery, 40, 135); // Apply currentScreen.scrollY to text position
  }
}


void drawSearchButton() {
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
  fill(100, 93, 170);
  textFont(flightInfoFont);
  textSize(14.8);
  textAlign(LEFT, 60);

  int centerX = (width - 550) / 2;
  int centerBox = centerX + 225;
  int y = initial_y2 - currentScreen.scrollY;

  text("Total Flights: " + filteredFlights.size(), 30, 190);

  for (int i = 0; i < filteredFlights.size(); i++) {
    Flight flight = filteredFlights.get(i);

    int boxX = centerX;
    int boxY = y;
    int boxWidth = 550;
    int boxHeight = 100;

    // Only Draw flights within the size of Screen
    if (boxY + boxHeight < 0 || boxY > height) {
      y += boxHeight + 10;
      continue;
    }

    // only set color once
    if (flight.cancelled) {
      fill(#934C4C, 220);
    } else if (flight.diverted) {
      fill(#E08A09, 220);
    } else {
      fill(#7CD1E8, 220);
    }

    // background
    stroke(0);
    rect(boxX, boxY, boxWidth, boxHeight, 10);

    // draw Text
    fill(0);
    textSize(16);
    text(flight.flightNumber, boxX + 50, boxY + 20);
    text(flight.fromattedDate, boxX + 350, boxY + 20);

    textSize(20);
    text(flight.originCity, boxX + 50, boxY + 60);
    text(flight.formattedDepTime, boxX + 70, boxY + 85);

    text(flight.destCity, boxX + 330, boxY + 60);
    text(flight.formattedArrTime, boxX +  350, boxY + 85);

    // Icon and Logo
    image(planeIcon, centerBox + 20, boxY + 30, 30, 30);

    textSize(18);
    text(flight.distance + " km", centerBox, boxY + 75);

    // status
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
  fill(255, 0, 0);
  textSize(20);
  text("Invalid input. Try Again, please enter a valid city full name only.", 30, 220 + currentScreen.scrollY); // Apply currentScreen.scrollY to warning
}


void keyPressed() {
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
  searchQuery = "";
  searchByOrigin = false;
  searchByArrival = false;
  showFlights = false;
  filteredFlights.clear();
  inputError = false;
}


void printUserInput() {
  println("User input: " + searchQuery);
}
