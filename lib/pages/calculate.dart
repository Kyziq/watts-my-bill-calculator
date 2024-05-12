import 'package:watts_my_bill/common/assets.dart';
import 'package:watts_my_bill/common/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:watts_my_bill/models/bill_calculation.dart';
import 'package:toastification/toastification.dart';

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
  String formattedPriceAfterRebate = '';
  BillDetails? billDetails;

  void calculateBill() {
    try {
      final int unitsUsed = int.parse(_unitsController.text);
      final double rebatePercentage = double.parse(_rebateController.text) /
          100; // Convert percentage input to a decimal
      billDetails =
          BillCalculation.calculateElectricityBill(unitsUsed, rebatePercentage);

      setState(() {
        formattedPrice = 'RM${billDetails?.price.toStringAsFixed(2)}';
        formattedRebate = '-RM${billDetails?.rebate.toStringAsFixed(2)}';
        formattedPriceAfterRebate =
            'RM${billDetails?.priceAfterRebate.toStringAsFixed(2)}';
        showResultCard = true;
      });
    } catch (e) {
      String errorMessage = e is FormatException
          ? 'Please enter valid numbers.'
          : (e is ArgumentError ? e.message : 'An unexpected error occurred.');

      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
        title: const Text('Error!'),
        description: Text(errorMessage.toString()),
        alignment: Alignment.bottomCenter,
        animationDuration: const Duration(milliseconds: 300),
        borderRadius: BorderRadius.circular(12.0),
        showProgressBar: true,
        closeButtonShowType: CloseButtonShowType.onHover,
        closeOnClick: true,
        dragToClose: true,
      );

      setState(() {
        showResultCard = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: 'Watt\'s My Bill',
      children: [
        _buildCalculationForm(context),
        const SizedBox(height: 20),
        _buildResultCard(),
      ],
    );
  }

  Widget _buildCalculationForm(BuildContext context) {
    final theme = ShadTheme.of(context);

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
    if (!showResultCard || billDetails == null) return const SizedBox.shrink();

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
                Text(formattedPriceAfterRebate),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
