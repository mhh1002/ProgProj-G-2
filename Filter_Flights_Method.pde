// Searches flights by origin or destination city
void searchFlights() {
  filteredFlights.clear();
  inputError = false;

  if (!validateInput()) {
    inputError = true;  // Show error if no matching cities found
    return;
  }

  // Find all matching flights (case-insensitive)
  for (Flight f : flights) {
    if (searchByOrigin && f.formattedOrigin.equalsIgnoreCase(searchQuery.trim())) {
      filteredFlights.add(f);
    } else if (searchByArrival && f.formattedArrival.equalsIgnoreCase(searchQuery.trim())) {
      filteredFlights.add(f);
    }
  }
}

// Validates if search query matches any city in database
boolean validateInput() {
  String searchQueryTrimmed = searchQuery.trim().toLowerCase();

  for (Flight f : flights) {
    if (searchByOrigin && f.formattedOrigin.toLowerCase().equals(searchQueryTrimmed)) {
      return true;
    }
    if (searchByArrival && f.formattedArrival.toLowerCase().equals(searchQueryTrimmed)) {
      return true;
    }
  }
  return false;  // No matching city found
}
