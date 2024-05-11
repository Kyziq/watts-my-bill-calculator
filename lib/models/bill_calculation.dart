class BillDetails {
  final double price;
  final double rebate;
  final double priceAfterRebate;

  BillDetails(
      {required this.price,
      required this.rebate,
      required this.priceAfterRebate});
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

  BillCalculation(double units, double rebate); // Rate for 601 kWh onwards

  /// Calculates the total electricity bill based on the units consumed and rebate percentage.
  ///
  /// [unitsUsed] specifies the total number of electricity units (kWh) used.
  /// [rebatePercentage] is the percentage rebate applied to the total bill.
  /// Returns the final bill amount in RM after applying the rebate.
  static BillDetails calculateElectricityBill(
      int unitsUsed, double rebatePercentage) {
    if (unitsUsed < 0) {
      throw ArgumentError('Units used must not be negative.');
    }

    // Validate rebate percentage is within the allowed range (0% to 5%)
    if (rebatePercentage < 0.0 || rebatePercentage > 0.05) {
      throw ArgumentError('Rebate percentage must be between 0% and 5%.');
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
    double rebate = price * rebatePercentage;
    double priceAfterRebate = price - rebate;

    return BillDetails(
        price: price, rebate: rebate, priceAfterRebate: priceAfterRebate);
  }
}
