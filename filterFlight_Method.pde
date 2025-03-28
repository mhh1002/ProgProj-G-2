void searchFlights() {
  filteredFlights.clear();
  inputError = false;

  if (!validateInput()) {
    inputError = true;
    return;
  }

  // Iterate over the flights to find matching ones based on the search criteria
  for (Flight f : flights) {
    if (searchByOrigin) {
      if ( f.originCity.toLowerCase().contains(searchQuery.trim().toLowerCase())) {
        filteredFlights.add(f);
      }
    } else if (searchByArrival) {
      if ( f.destCity.toLowerCase().contains(searchQuery.trim().toLowerCase())) {
        filteredFlights.add(f);
      }
    }
  }
}


boolean validateInput() {
  boolean found = false;

  for (Flight f : flights) {
    String searchQueryTrimmed = searchQuery.trim().toLowerCase();

    if (searchByOrigin) {
      if ( f.originCity.toLowerCase().contains(searchQueryTrimmed)) {
        found = true;
      }
    } else if (searchByArrival) {
      if ( f.destCity.toLowerCase().contains(searchQueryTrimmed)) {
        found = true;
      }
    }
  }

  return found;
}
