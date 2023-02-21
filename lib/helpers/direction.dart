String direction(degree) {
  if (348.75 <= degree || degree < 11.25) {
    return "N";
  }
  if (11.25 <= degree && degree < 33.75) {
    return "NNE";
  }
  if (33.75 <= degree && degree < 56.25) {
    return "NE";
  }
  if (56.25 <= degree && degree < 78.75) {
    return "ENE";
  }
  if (78.75 <= degree && degree < 101.25) {
    return "E";
  }
  if (101.25 <= degree && degree < 123.75) {
    return "ESE";
  }
  if (123.75 <= degree && degree < 146.25) {
    return "SE";
  }
  if (146.25 <= degree && degree < 168.75) {
    return "SSE";
  }
  if (168.75 <= degree && degree < 191.25) {
    return "S";
  }
  if (191.25 <= degree && degree < 213.75) {
    return "SSW";
  }
  if (213.75 <= degree && degree < 236.25) {
    return "SW";
  }
  if (236.25 <= degree && degree < 258.75) {
    return "WSW";
  }
  if (258.75 <= degree && degree < 281.25) {
    return "W";
  }
  if (281.25 <= degree && degree < 303.75) {
    return "WNW";
  }
  if (303.75 <= degree && degree < 326.25) {
    return "NW";
  }
  if (326.25 <= degree && degree < 348.75) {
    return "NNW";
  } else {
    return "";
  }
}
