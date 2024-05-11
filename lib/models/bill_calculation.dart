/// A utility class for calculating electricity bills based on tiered rates and rebates.
class BillCalculation {
  // Defined in sen per kWh for different blocks of usage
  static const double _rateForFirst200kWh = 21.8; // Rate for the first 200 kWh
  static const double _rateForNext100kWh = 33.4; // Rate for 201 to 300 kWh
  static const double _rateForNext300kWh = 51.6; // Rate for 301 to 600 kWh
  static const double _rateBeyond600kWh = 54.6;

  BillCalculation(double units, double rebate); // Rate for 601 kWh onwards

  /// Calculates the total electricity bill based on the units consumed and rebate percentage.
  ///
  /// [unitsUsed] specifies the total number of electricity units (kWh) used.
  /// [rebatePercentage] is the percentage rebate applied to the total bill.
  /// Returns the final bill amount in RM after applying the rebate.
  static double calculateElectricityBill(
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
      bill += (unitsUsed - 600) * _rateBeyond600kWh;
      unitsUsed = 600;
    }
    if (unitsUsed > 300) {
      bill += (unitsUsed - 300) * _rateForNext300kWh;
      unitsUsed = 300;
    }
    if (unitsUsed > 200) {
      bill += (unitsUsed - 200) * _rateForNext100kWh;
      unitsUsed = 200;
    }
    bill += unitsUsed * _rateForFirst200kWh;

    double totalBill = bill / 100; // Convert sen to RM
    double discount = totalBill * rebatePercentage;
    return totalBill - discount;
  }
}
