class BillDetails {
  final double price;
  final double rebate;
  final double netTotal;

  BillDetails(
      {required this.price, required this.rebate, required this.netTotal});
}

class BillCalculation {
  // Defined in sen per kWh for different blocks of usage
  static const double _firstBlock =
      21.8; // For the first 200 kWh (1 - 200 kWh) per month
  static const double _secondBlock =
      33.4; // For the next 100 kWh (201 - 300 kWh) per month
  static const double _thirdBlock =
      51.6; // For the next 300 kWh (301 - 600 kWh) per month
  static const double _fourthBlock =
      54.6; // For the next 300 kWh (601 - 900 kWh) per month onwards

  static BillDetails calculateBill(String unitsText, String rebateText) {
    if (unitsText.isEmpty) {
      throw const FormatException('Please enter the number of units used.');
    }

    final int units = int.tryParse(unitsText) ?? -1;
    if (units < 0) {
      throw const FormatException('Invalid number of units.');
    }

    double rebateRate = 0.0;
    if (rebateText.isNotEmpty) {
      final double parsedRebate = double.tryParse(rebateText) ?? -1.0;
      rebateRate = parsedRebate / 100;
      if (rebateRate < 0.0 || rebateRate > 0.05) {
        throw const FormatException('Rebate must be between 0% and 5%.');
      }
    }

    return _performCalculation(units, rebateRate);
  }

  /// Calculates the total electricity bill based on the units consumed and rebate percentage.
  static BillDetails _performCalculation(int unitsUsed, double rebatePercent) {
    if (unitsUsed < 0) {
      throw const FormatException('Units used must not be negative.');
    }

    // Validate rebate percentage is within the allowed range (0% to 5%)
    if (rebatePercent < 0.0 || rebatePercent > 0.05) {
      throw const FormatException(
          'Rebate percentage must be between 0% and 5%.');
    }

    double bill = 0.0;

    // Calculation
    if (unitsUsed > 600) {
      bill += (unitsUsed - 600) * _fourthBlock;
      unitsUsed = 600;
    }
    if (unitsUsed > 300) {
      bill += (unitsUsed - 300) * _thirdBlock;
      unitsUsed = 300;
    }
    if (unitsUsed > 200) {
      bill += (unitsUsed - 200) * _secondBlock;
      unitsUsed = 200;
    }
    bill += unitsUsed * _firstBlock;

    double price = bill / 100; // Convert sen to RM
    double rebate = price * rebatePercent;
    double netTotal = price - rebate;

    return BillDetails(price: price, rebate: rebate, netTotal: netTotal);
  }
}
