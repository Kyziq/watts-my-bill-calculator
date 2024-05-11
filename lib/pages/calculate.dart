import 'package:watts_my_bill/common/assets.dart';
import 'package:watts_my_bill/common/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:watts_my_bill/models/bill_calculation.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    void calculateBill() {
      try {
        final int unitsUsed = int.parse(_unitsController.text);
        final double rebatePercentage = double.parse(_rebateController.text) /
            100; // Convert percentage input to a decimal
        billDetails = BillCalculation.calculateElectricityBill(
            unitsUsed, rebatePercentage);

        setState(() {
          formattedPrice = 'RM${billDetails?.price.toStringAsFixed(2)}';
          formattedRebate = '-RM${billDetails?.rebate.toStringAsFixed(2)}';
          formattedPriceAfterRebate =
              'RM${billDetails?.priceAfterRebate.toStringAsFixed(2)}';
          showResultCard = true;
        });
      } catch (e) {
        // Handle errors, such as invalid input format
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }

    return BaseScaffold(
      appBarTitle: 'Calculator',
      children: [
        ShadCard(
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
                const Text('Units Used (kWh)'),
                ShadInput(
                    controller: _unitsController,
                    placeholder: const Text('insert number of units'),
                    keyboardType: TextInputType.number),
                const SizedBox(height: 6),
                const Text('Rebate Percentage (%)'),
                ShadInput(
                  controller: _rebateController,
                  placeholder: const Text('insert rebate percentage'),
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
                onPressed: () {
                  calculateBill();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (showResultCard == true && billDetails != null)
          ShadCard(
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
          ),
      ],
    );
  }
}
