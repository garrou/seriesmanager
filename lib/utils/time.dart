class Time {
  static const int minsInHour = 60;

  static const int minsInDay = 1440;

  static String minsToStringHours(int mins) =>
      '${mins ~/ minsInHour} h ${mins % minsInHour} mins';

  static String minsToStringDays(int mins) =>
      '${(mins / minsInDay).toStringAsFixed(2)} jours';
}
