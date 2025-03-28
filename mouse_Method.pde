void mouseWheel(MouseEvent event) {
  if (!mainScreenOn && currentScreen != null) {
    currentScreen.scrollY += event.getCount() * rowHeight;

    int maxScroll = 0;

    if (currentScreen == canDelFlights) {
      maxScroll = max(0, flightsForDate.size() * rowHeight - (height - 60));
    } else if (currentScreen == originCityScr || currentScreen == arrivalCityScr) {
      maxScroll = max(0, filteredFlights.size() * 20 - (height - 210));
    }

    currentScreen.scrollY = constrain(currentScreen.scrollY, 0, maxScroll);
  }
}


void mousePressed() {
  int event = -1;
  if (mainScreenOn) {
    event = myMainScreen.getEvent(mouseX, mouseY);
  } else {
    if (currentScreen != null && currentScreen.backButton != null) {
      event = currentScreen.backButton.getEvent(mouseX, mouseY);
    }

    // Handle bar chart clicks when on canDelLatScr screen
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
        return; // Exit to prevent other event processing
      } else if (mouseX > cancelledBarX && mouseX < cancelledBarX + barWidth &&
        mouseY > cancelledBarTop && mouseY < cancelledBarBtm) {
        onBarClick(true); // Show cancelled flights
        return; // Exit to prevent other event processing
      }
    }
  }

  // Handle search button click
  if (mouseX > searchButtonX && mouseX < searchButtonX + searchButtonW &&
    mouseY > searchButtonY && mouseY < searchButtonY + searchButtonH) {
    searchFlights();
    return;
  }

  switch(event) {

  case BACK:
    resetSearch();
    if (currentScreen == canDelFlights) {
      mainScreenOn = false;
      currentScreen = canDelLatScr;
    } else {
      mainScreenOn = true;
      currentScreen = null;
    }
    break;

  case DATE_RANGE:
    resetSearch();
    mainScreenOn = false;
    currentScreen = monthlyFlightScr;
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
