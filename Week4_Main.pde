import java.util.*;
import processing.data.Table;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;

PFont stdFont;
PFont labelFont;
PFont flightInfoFont;
final int DATE_RANGE = 1;
final int ORIGIN_CITY = 2;
final int ARRIVAL_CITY = 3;
final int CAN_DEL_LAT = 4;
final int BACK = 5;
final int CAN_DEL_DETAILS = 6;
final int EVENT_NULL = 0;
final int GAP = 15;

final int SORT_ASC = 7;    
final int SORT_DESC = 8; 
final int SORT_AZ = 9;    
final int SORT_ZA = 10;  
final int SORT_TYPE_DATE = 0;
final int SORT_TYPE_CITY = 1;

final int initial_y2 = 220;
final int initial_y = 60;
final int initial_x = 10;
int scrollOffset = 0;
int rowHeight = 30;
int selectedBarIndex = -1;
int cancelledCount = 0; // Count for cancelled (1)
int notCancelledCount = 0; // Count for not cancelled (0)
float notCancelledHeight;
float cancelledHeight;
boolean showFlightScreen = false; // Switch between bar chart and flight details screen
String selectedDate = "";

boolean sortAscending = true;    // 
boolean currentSortAZ = true;    // 
int currentSortType = -1;        // 
//
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
Screen monthlyFlightScr, originCityScr, arrivalCityScr, canDelLatScr, canDelFlights;
Screen currentScreen;
color event_Color;

int searchButtonX = 280;
int searchButtonY = 120;
int searchButtonW = 80;
int searchButtonH = 40;


void setup() {
  size(1300, 750);

  color labelColor = color(0, 10, 97);
  stdFont = loadFont("AlNile-40.vlw");
  labelFont = loadFont("FZLTXHB--B51-0-20.vlw");
  flightInfoFont = createFont("Arial", 15);

  flightsForDate = new ArrayList<Flight>();

  myMainScreen = new MainScreen("Monthly flights", "Origin city",
    "Arrival city", "Cancelled/Delayed/Late flights", labelColor, 230);

  monthlyFlightScr = new Screen("Monthly Flights Search", 20, 65, labelColor, 230, -1600);
  originCityScr = new Screen("Origin City Search", 20, 65, labelColor, 230, -9000);
  arrivalCityScr = new Screen("Arrival City Search", 20, 65, labelColor, 230, -9000);
  canDelLatScr = new Screen("Cancelled/Delayed/Late Flights Search", 10, 20, labelColor, 230, 0);
  canDelFlights = new Screen("Flights Info", 10, 5, labelColor, 230, -9000);
  mainScreenOn = true;

  readData("flights_full.csv");
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
    }
  } else {
    myMainScreen.draw(color(0, 41, 224));
  }
}


void displayFlights() {
  fill(100, 93, 170);
  textFont(flightInfoFont);
  textSize(14.8);
  int y = initial_y - currentScreen.scrollY; // intial y position

  for (int i = 0; i < flightsForDate.size(); i++) {
    Flight dp = flightsForDate.get(i);

    if (y > 60 && y < height - 15) {
      String flightInfo = dp.getDisplayString();
      textAlign(LEFT, 60);
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
    text("Enter city full name to search", 40, 145); // Apply currentScreen.scrollY to text position
  } else {
    fill(0);
    text(searchQuery, 40, 145); // Apply currentScreen.scrollY to text position
  }
}


void drawSearchButton() {
  fill(color(0, 10, 97));

  if (mouseX > searchButtonX && mouseX < searchButtonX + searchButtonW && mouseY > searchButtonY
    && mouseY < searchButtonY + searchButtonH) {
    fill(color(0, 41, 224));
  } else {
    fill(color(0, 10, 97));
    rect(searchButtonX, searchButtonY, searchButtonW, searchButtonH, 10); // Apply currentScreen.scrollY to button position
    fill(255);
    textSize(16);
    text("Search", searchButtonX + 15, searchButtonY + 15);// Apply currentScreen.scrollY to text position
  }
}


//void displayFilteredFlights() {
//  //float y = 210 - currentScreen.scrollY;
//  fill(0);
//  textSize(12);
//  int y = initial_y2 - currentScreen.scrollY; // intial y position

//  if (!filteredFlights.isEmpty() && y > 30 && y < height -30) {
//    text("Total Flights: " + filteredFlights.size(), initial_x, y);
//    y += 20; // Spacing



//    for (Flight flight : filteredFlights) {
//      text(flight.toString(), initial_x, y);
//      //y += 20;
//      y += rowHeight;
//    }
//  }
//}

void displayFilteredFlights() {
  fill(100, 93, 170);
  textFont(flightInfoFont);
  textSize(14.8);
  textAlign(LEFT, 60);
   String sortStatus = "";
  if(!filteredFlights.isEmpty()) {
    sortStatus += "Sorted by: ";
    if(currentSortType == 0) {
      sortStatus += "Date " + (sortAscending ? "ASC" : "DESC");
    } else {
      String cityType = searchByOrigin ? "Destination" : "Origin";
      sortStatus += cityType + " " + (currentSortAZ ? "A-Z" : "Z-A");
    }
    text(sortStatus, initial_x, 170);
  }

  int y = initial_y2 - currentScreen.scrollY;

  text("Total Flights: " + filteredFlights.size(), initial_x, 190);

  for (int i = 0; i < filteredFlights.size(); i++) {
    Flight flight = filteredFlights.get(i);

    if (y > 200 && y < height - 15) {
      text(flight.toString(), initial_x, y);
    }

    y += rowHeight;
  }
}




void displayWarning() {
  fill(255, 0, 0);
  textSize(14);
  text("Invalid input. Please enter a valid city abbreviation or full name.", 30, 220 + currentScreen.scrollY); // Apply currentScreen.scrollY to warning
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
