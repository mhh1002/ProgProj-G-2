final int SORT_ASC = 6;
final int SORT_DESC = 7;
boolean sortAscending = true;


Widget sortAscBtn, sortDescBtn; // in class screen

// in function  Screen(String screenName, int Xpos, float Ypos, color labelColor, color backgroundColor, float maxScroll)

this.sortAscBtn = new Widget(700, 180, 120, 40, "Sort ASC", 
              color(200), labelFont, SORT_ASC);
this.sortDescBtn = new Widget(830, 180, 120, 40, "Sort DESC", 
               color(200), labelFont, SORT_DESC);

// inScreen draw()
sortAscBtn.draw();
sortAscBtn.changeColor(mouseX, mouseY, mouseHoverColor);
sortDescBtn.draw();
sortDescBtn.changeColor(mouseX, mouseY, mouseHoverColor);

// class Screen
int getSortEvent(int mX, int mY) {
  int event = sortAscBtn.getEvent(mX, mY);
  if(event != EVENT_NULL) return event;
  return sortDescBtn.getEvent(mX, mY);
}


// in void mousePressed

if(currentScreen != null && !mainScreenOn) {
  int sortEvent = currentScreen.getSortEvent(mouseX, mouseY);
  if(sortEvent == SORT_ASC) {
    sortFlights(true);
  } else if(sortEvent == SORT_DESC) {
    sortFlights(false);
  }
}

update void mousePressed:
void mousePressed() {
  int event = -1;
  if (mainScreenOn)
  {
    event = myMainScreen.getEvent(mouseX, mouseY);
  } else
  {
    if (currentScreen != null && currentScreen.w != null)
    {
      event = currentScreen.w.getEvent(mouseX, mouseY);
    }
  }

  // Handle search button click
  if (mouseX > searchButtonX && mouseX < searchButtonX + searchButtonW &&
    mouseY > searchButtonY && mouseY < searchButtonY + searchButtonH)
  {
    searchFlights();
  }

  switch (event)
  {
  case DATE_RANGE:
    resetSearch();
    mainScreenOn = false;
    currentScreen = dateRangeScr;
    break;

  case ORIGIN_CITY:
    resetSearch();
    searchByOrigin = true;
    searchByArrival = false;
    mainScreenOn = false;
    currentScreen = originCityScr;
    break;

  case ARRIVAL_CITY:
    resetSearch();
    searchByOrigin = false;
    searchByArrival = true;
    mainScreenOn = false;
    currentScreen = arrivalCityScr;
    break;

  case CAN_DEL_LAT:
    resetSearch();
    mainScreenOn = false;
    currentScreen = canDelLatScr;
    break;

  default:
    if (currentScreen != null && !mainScreenOn)
    {
      event = currentScreen.w.getEvent(mouseX, mouseY);
      if (event == BACK)
      {
        resetSearch();
        mainScreenOn = true;
        currentScreen = null;
      }
    }
    break;
  }
  if (currentScreen != null && !mainScreenOn) {
    //
    int sortEvent = currentScreen.getSortEvent(mouseX, mouseY);
    if (sortEvent == SORT_ASC) {
      sortFlights(true); // 
    } else if (sortEvent == SORT_DESC) {
      sortFlights(false); //
    }
  }
}
//viod update in main:
void sortFlights(boolean ascending) {
  Collections.sort(filteredFlights, new Comparator<Flight>() {
    public int compare(Flight f1, Flight f2) {
      Date date1 = parseDate(f1.flightDate);
      Date date2 = parseDate(f2.flightDate);
      return ascending ? date1.compareTo(date2) : date2.compareTo(date1);
    }
  });
  sortAscending = ascending;
}

Date parseDate(String dateStr) {
  try {
    // 1/1/2022 12:00:00 AM
    String[] dateParts = split(dateStr, ' ');
    String[] mdy = split(dateParts[0], '/');
    int month = int(mdy[0])-1; // month from 1
    int day = int(mdy[1]);
    int year = int(mdy[2]);
    return new Date(year-1900, month, day);
  } catch(Exception e) {
    return new Date(0);
  }
}

//update displayFilteredFlights in main

void displayFilteredFlights() {
  float y = 240 - scrollY;
  fill(0);
  textSize(12);

  if (!filteredFlights.isEmpty()) {
    // New display of sorting status
    text("Sorted by date: " + (sortAscending ? "ASC" : "DESC"), 30, y);
    y += 20; 


    text("Total Flights: " + filteredFlights.size(), 30, y);
    y += 20; // Spacing
  }

  for (Flight flight : filteredFlights) {
    text(flight.toString(), 30, y);
    y += 20;
  }
}
