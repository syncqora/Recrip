/// Utilities for subscription/plan calculations.

/// Returns the expiry date for a plan starting on [startDate], or null if
/// plan or startDate is null.
/// - Monthly: start + 1 month
/// - Quarterly: start + 3 months
/// - Yearly: start + 1 year
DateTime? calculateExpiryDate(String? plan, DateTime? startDate) {
  if (plan == null || startDate == null) return null;
  switch (plan) {
    case 'Monthly':
      return _addMonths(startDate, 1);
    case 'Quarterly':
      return _addMonths(startDate, 3);
    case 'Yearly':
      return _addMonths(startDate, 12);
    default:
      return null;
  }
}

DateTime _addMonths(DateTime from, int months) {
  int year = from.year;
  int month = from.month + months;
  while (month > 12) {
    month -= 12;
    year++;
  }
  while (month < 1) {
    month += 12;
    year--;
  }
  final lastDay = DateTime(year, month + 1, 0).day;
  final day = from.day <= lastDay ? from.day : lastDay;
  return DateTime(year, month, day);
}
