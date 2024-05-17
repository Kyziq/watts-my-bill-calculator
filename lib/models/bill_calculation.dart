import 'package:watts_my_bill/models/tariff_rates.dart';

class BillDetails {
  final double price;
  final double rebate;
  final double netTotal;

  BillDetails(
      {required this.price, required this.rebate, required this.netTotal});
}

class BillCalculation {
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
    double bill = 0.0;

    for (final TariffRate rate in TariffRates.rates) {
      final int unitsInRange = _calculateUnitsInRange(unitsUsed, rate);
      bill += unitsInRange * rate.rate;
      unitsUsed -= unitsInRange;
      if (unitsUsed <= 0) break; // Stop if all units are accounted for
    }

    double price = bill / 100; // Convert sen to RM
    double rebate = price * rebatePercent;
    double netTotal = price - rebate;

    return BillDetails(price: price, rebate: rebate, netTotal: netTotal);
  }

  static int _calculateUnitsInRange(int unitsUsed, TariffRate rate) {
    if (rate.end == -1) return unitsUsed; // No upper limit
    final int rangeUnits =
        rate.end - rate.start + 1; // Plus one because it's inclusive
    return unitsUsed >= rangeUnits ? rangeUnits : unitsUsed;
  }
}
