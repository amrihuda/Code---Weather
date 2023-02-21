bool isSameDay(DateTime? dateA, DateTime? dateB) {
  return dateA?.year == dateB?.year &&
      dateA?.month == dateB?.month &&
      dateA?.day == dateB?.day;
}

bool isSameHour(DateTime? dateA, DateTime? dateB) {
  return dateA?.hour == dateB?.hour;
}
