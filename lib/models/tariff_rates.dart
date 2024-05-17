// TNB Domestic Tariff Rates
// https://www.tnb.com.my/residential/pricing-tariffs

class TariffRate {
  final int start;
  final int end;
  final double rate;
  final String rateUnit;
  final String unit;

  const TariffRate(this.start, this.end, this.rate)
      : rateUnit = 'sen/kWh',
        unit = 'kWh';

  String get range => end > 0 ? '$start - $end' : '$start';
}

class TariffRates {
  // Defined in sen per kWh for different blocks of usage
  static const double _firstBlock =
      21.8; // For the first 200 kWh (1 - 200 kWh) per month
  static const double _secondBlock =
      33.4; // For the next 100 kWh (201 - 300 kWh) per month
  static const double _thirdBlock =
      51.6; // For the next 300 kWh (301 - 600 kWh) per month
  static const double _fourthBlock =
      54.6; // For the next 300 kWh (601 - 900 kWh) per month onwards
  static const double _fifthBlock =
      57.1; // For the next kWh (901 kWh onwards) per month

  static const List<TariffRate> rates = [
    TariffRate(1, 200, _firstBlock),
    TariffRate(201, 300, _secondBlock),
    TariffRate(301, 600, _thirdBlock),
    TariffRate(601, 900, _fourthBlock),
    TariffRate(901, -1, _fifthBlock), // -1 indicates no upper limit
  ];
}
