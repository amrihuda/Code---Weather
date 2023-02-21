toCelsius(value) {
  String result = "${(value - 273.15).round().toString()}\u2103";
  return result;
}

toFahrenheit(value) {
  String result = "${(value - 273.15).round().toString()}\u2109";
  return result;
}
