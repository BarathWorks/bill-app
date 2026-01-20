/// Utility functions for precise decimal calculations in billing
class DecimalUtils {
  DecimalUtils._();

  /// Rounds to 2 decimal places
  static double roundToTwo(double value) {
    return (value * 100).roundToDouble() / 100;
  }

  /// Formats amount to string with 2 decimals
  static String formatAmount(double amount) {
    return amount.toStringAsFixed(2);
  }

  /// Formats amount with currency symbol (₹)
  static String formatCurrency(double amount) {
    return '₹ ${formatAmount(amount)}';
  }

  /// Formats amount with comma separators for Indian numbering
  static String formatIndianCurrency(double amount) {
    String amountStr = formatAmount(amount);
    List<String> parts = amountStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Apply Indian numbering system (XX,XX,XXX)
    if (integerPart.length > 3) {
      String lastThree = integerPart.substring(integerPart.length - 3);
      String remaining = integerPart.substring(0, integerPart.length - 3);
      
      // Add commas every 2 digits for remaining part
      RegExp reg = RegExp(r'\B(?=(\d{2})+(?!\d))');
      remaining = remaining.replaceAllMapped(reg, (match) => ',');
      
      integerPart = '$remaining,$lastThree';
    }

    return '₹ $integerPart$decimalPart';
  }

  /// Safe multiplication with rounding
  static double multiply(double a, double b) {
    return roundToTwo(a * b);
  }

  /// Safe addition with rounding
  static double add(double a, double b) {
    return roundToTwo(a + b);
  }

  /// Safe subtraction with rounding
  static double subtract(double a, double b) {
    return roundToTwo(a - b);
  }

  /// Calculate total from a list of amounts
  static double calculateTotal(List<double> amounts) {
    return roundToTwo(amounts.fold(0.0, (sum, amount) => sum + amount));
  }

  /// Parse string to double safely
  static double parseDouble(String value, {double defaultValue = 0.0}) {
    try {
      return double.parse(value.trim());
    } catch (_) {
      return defaultValue;
    }
  }
}
