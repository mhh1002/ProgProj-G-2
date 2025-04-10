// Handles mouse wheel scrolling for different screens
void mouseWheel(MouseEvent event) {
  if (!mainScreenOn && currentScreen != null) {
    float scrollSensitivity = 0.4; // Controls scroll speed
    currentScreen.scrollY += event.getCount() * rowHeight * scrollSensitivity;

    // Calculate max scroll position based on current screen type
    int maxScroll = 0;
    if (currentScreen == canDelFlights) {
      maxScroll = max(0, flightsForDate.size() * rowHeight - (height - 70));
    } else if (currentScreen == originCityScr || currentScreen == arrivalCityScr) {
      maxScroll = max(0, filteredFlights.size() * 20 - (height - 210));
    } else if (currentScreen == dailyFlightsInfo) {
      maxScroll = max(0, flightData.size() * rowHeight - (height - 100));
    }

    currentScreen.scrollY = constrain(currentScreen.scrollY, 0, maxScroll);
  }
}

// Main mouse click handler for all UI interactions
void mousePressed() {
  // Handle sorting buttons if not on main screen
  if (currentScreen != null && !mainScreenOn) {
    int sortEvent = currentScreen.getSortEvent(mouseX, mouseY);
    switch(sortEvent) {
    case SORT_ASC:
      sortFlights(true, false);  // Sort by date ascending
      currentSortType = SORT_TYPE_DATE;
      sortAscending = true;
      break;
    case SORT_DESC:
      sortFlights(false, false); // Sort by date descending
      currentSortType = SORT_TYPE_DATE;
      sortAscending = false;
      break;
    case SORT_AZ:
      sortFlights(true, true);   // Sort city A-Z
      currentSortType = SORT_TYPE_CITY;
      currentSortAZ = true;
      break;
    case SORT_ZA:
      sortFlights(false, true);  // Sort city Z-A
      currentSortType = SORT_TYPE_CITY;
      currentSortAZ = false;
      break;
    }
  }

  // Determine which UI element was clicked
  int event = -1;
  if (mainScreenOn) {
    event = myMainScreen.getEvent(mouseX, mouseY);
  } else {
    if (currentScreen != null && currentScreen.backButton != null) {
      event = currentScreen.backButton.getEvent(mouseX, mouseY);
    }

    // Handle clicks on cancellation/delay bars
    if (currentScreen == canDelLatScr) {
      int margin = 100;
      int barWidth = (width - 2 * margin) / 2;
      int cancelledBarX = margin + barWidth + 20;
      int notCancelledBarX = margin;
      float cancelledBarTop = height - margin - cancelledHeight;
      float cancelledBarBtm = cancelledBarTop + cancelledHeight;
      float notCancelledBarTop = height - margin - notCancelledHeight;
      float notCancelledBarBtm = notCancelledBarTop + notCancelledHeight;

      if (mouseX > notCancelledBarX && mouseX < notCancelledBarX + barWidth &&
        mouseY > notCancelledBarTop && mouseY < notCancelledBarBtm) {
        onBarClick(false); // Show non-cancelled flights
        return;
      } else if (mouseX > cancelledBarX && mouseX < cancelledBarX + barWidth &&
        mouseY > cancelledBarTop && mouseY < cancelledBarBtm) {
        onBarClick(true); // Show cancelled flights
        return;
      }
    }

    // Handle clicks on daily flight bars
    if (currentScreen == monthlyFlightScr) {
      int barWidth = (width - 2 * margin) / 31;
      int clickedBar = (mouseX - margin) / barWidth;

      if (clickedBar >= 0 && clickedBar < 31 &&
        mouseY >= margin + 50 && mouseY <= height - margin) {
        onBarClickForDaily(clickedBar + 1);  // Convert to 1-31 day format
        return;
      }
    }
  }

  // Handle search button click
  if (mouseX > searchButtonX && mouseX < searchButtonX + searchButtonW &&
    mouseY > searchButtonY && mouseY < searchButtonY + searchButtonH) {
    searchFlights();
    return;
  }

  // Handle screen navigation based on clicked element
  switch(event) {
  case BACK:
    resetSearch();
    if (currentScreen == canDelFlights) {
      mainScreenOn = false;
      currentScreen = canDelLatScr;
    } else if (currentScreen == dailyFlightsInfo) {
      mainScreenOn = false;
      currentScreen = monthlyFlightScr;
    } else {
      mainScreenOn = true;
      currentScreen = null;
    }
    break;

  case DATE_RANGE:
    resetSearch();
    mainScreenOn = false;
    currentScreen = monthlyFlightScr; // Monthly flights chart screen
    currentScreen.scrollY = 0;
    break;

  case ORIGIN_CITY:
    resetSearch();
    searchByOrigin = true;
    searchByArrival = false;
    mainScreenOn = false;
    currentScreen = originCityScr;
    currentScreen.scrollY = 0;
    break;

  case ARRIVAL_CITY:
    resetSearch();
    searchByOrigin = false;
    searchByArrival = true;
    mainScreenOn = false;
    currentScreen = arrivalCityScr;
    currentScreen.scrollY = 0;
    break;

  case CAN_DEL_LAT:
    resetSearch();
    mainScreenOn = false;
    currentScreen = canDelLatScr;
    currentScreen.scrollY = 0;
    break;

  case CAN_DEL_DETAILS:
    resetSearch();
    mainScreenOn = false;
    currentScreen = canDelFlights;
    currentScreen.scrollY = 0;
    break;

  default:
    if (currentScreen != null && !mainScreenOn) {
      event = currentScreen.backButton.getEvent(mouseX, mouseY);
      if (event == BACK) {
        resetSearch();
        mainScreenOn = true;
        currentScreen = null;
      }
    }
    break;
  }
}

// Sorts flights by date or city name
void sortFlights(boolean ascending, boolean isCitySort) {
  Collections.sort(filteredFlights, new Comparator<Flight>() {
    public int compare(Flight f1, Flight f2) {
      if (isCitySort) {
        String str1, str2;
        if (searchByOrigin) {
          str1 = f1.destCity.toLowerCase();
          str2 = f2.destCity.toLowerCase();
        } else {
          str1 = f1.originCity.toLowerCase();
          str2 = f2.originCity.toLowerCase();
        }
        return ascending ? str1.compareTo(str2) : str2.compareTo(str1);
      } else {
        Date date1 = parseDate(f1.flightDate);
        Date date2 = parseDate(f2.flightDate);
        return ascending ? date1.compareTo(date2) : date2.compareTo(date1);
      }
    }
  }
  );
}

// Converts date string to Date object
Date parseDate(String dateStr) {
  try {
    String[] parts = split(dateStr, ' ');
    String[] mdy = split(parts[0], '/');
    int month = int(mdy[0])-1; // Months are 0-based in Date
    int day = int(mdy[1]);
    int year = int(mdy[2]);
    return new Date(year-1900, month, day); // Date counts years from 1900
  }
  catch(Exception e) {
    return new Date(0); // Return epoch date on error
  }
}
