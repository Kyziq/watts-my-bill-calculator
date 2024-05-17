import 'package:watts_my_bill/utils/assets.dart';
import 'package:watts_my_bill/utils/constants.dart';
import 'package:watts_my_bill/common/base_scaffold.dart';
import 'package:watts_my_bill/utils/bill_calculation.dart';
import 'package:watts_my_bill/widgets/error_handling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _rebateController = TextEditingController();

  bool showResultCard = false;
  String formattedPrice = '';
  String formattedRebate = '';
  String formattedNetTotal = '';
  BillDetails? billDetails;

  void calculateBill() {
    try {
      BillDetails billDetails = BillCalculation.calculateBill(
          _unitsController.text, _rebateController.text);

      setState(() {
        formattedPrice = 'RM${billDetails.price.toStringAsFixed(2)}';
        formattedRebate = billDetails.rebate == 0.00
            ? '-'
            : '-RM${billDetails.rebate.toStringAsFixed(2)}';
        formattedNetTotal = 'RM${billDetails.netTotal.toStringAsFixed(2)}';
        showResultCard = true;
      });
    } on FormatException catch (e) {
      ErrorHandler.showError(context, e.message);
      setState(() {
        showResultCard = false;
      });
    }
  }

  void _showTariffDialog() {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text("TNB's Tariff A - Domestic Tariff Rates"),
        description: const Text(
          "\"Domestic Consumer\" means a consumer occupying a private dwelling, which is not used as a hotel, boarding house or used for the purpose of carrying out any form of business, trade, professional activities or services.",
          style: TextStyle(fontSize: 12),
        ),
        actions: [
          ShadButton(
            text: const Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: Constants.appName,
      showThemeToggle: true,
      children: [
        _buildCalculationForm(context),
        const SizedBox(height: 20),
        _buildResultCard(),
      ],
    );
  }

  Widget _buildCalculationForm(BuildContext context) {
    // TODO: Make use of ShadTheme
    // final theme = ShadTheme.of(context);

    return ShadCard(
      width: 350,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Bill Calculator'),
          const SizedBox(width: 8),
          ShadTooltip(
            builder: (context) =>
                const Text('Learn how your bill is calculated'),
            child: GestureDetector(
              onTap: _showTariffDialog,
              child: SvgPicture.asset(
                Assets.infoIcon,
                height: 20,
                width: 20,
              ),
            ),
          ),
        ],
      ),
      description: const Text(
        'Find out how much your electricity costs',
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Units Used, kWh'),
            ShadInputFormField(
              id: 'unitsUsed',
              controller: _unitsController,
              placeholder: const Text('insert number of units'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 6),
            const Text('Rebate Percentage, %'),
            ShadInputFormField(
              controller: _rebateController,
              placeholder: const Text('insert percentage (optional)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShadButton.outline(
            text: const Text('Reset'),
            onPressed: () {
              setState(() {
                _unitsController.clear();
                _rebateController.clear();
                showResultCard = false;
              });
            },
          ),
          ShadButton(
            text: const Text('Submit'),
            onPressed: calculateBill,
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    // If the result card is not to be shown, return an empty widget
    if (!showResultCard) return const SizedBox.shrink();

    return ShadCard(
      width: 380,
      title: const Text('Result'),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price:'),
                Text(formattedPrice),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rebate:'),
                Text(formattedRebate),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price after Rebate:'),
                Text(formattedNetTotal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _unitsController.dispose();
    _rebateController.dispose();
    super.dispose();
  }
}
