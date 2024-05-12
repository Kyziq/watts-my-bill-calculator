import 'package:watts_my_bill/utils/assets.dart';
import 'package:watts_my_bill/utils/constants.dart';
import 'package:watts_my_bill/common/base_scaffold.dart';
import 'package:watts_my_bill/models/bill_calculation.dart';
import 'package:watts_my_bill/widgets/error_handling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
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
        formattedRebate = '-RM${billDetails.rebate.toStringAsFixed(2)}';
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

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: Constants.appName,
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
          SvgPicture.asset(
            Assets.electricIcon,
            height: 20,
            width: 20,
          ),
        ],
      ),
      description: const Text(
        'Lets calculate your electricity bill!',
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
                Text(billDetails?.rebate != 0 ? formattedRebate : '-'),
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
}
