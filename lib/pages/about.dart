import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:watts_my_bill/common/base_scaffold.dart';
import 'package:watts_my_bill/utils/assets.dart';
import 'package:watts_my_bill/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse(Constants.githubProfileUrl);

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: 'Watt\'s My Bill',
      wrapChildrenInScrollable:
          false, // Now handled individually within children
      wrapSingleChildInColumn: false,
      showThemeToggle: true,
      children: [
        Expanded(
          // This will take all available space pushing the copyright to bottom
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const BuildProfilePicture(),
                const SizedBox(height: 20),
                ContactCard(onTap: _launchUrl),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: BuildCopyrightNotice(),
        ),
      ],
    );
  }
}

class BuildProfilePicture extends StatelessWidget {
  const BuildProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 80,
      backgroundImage: AssetImage(Assets.myPicture),
    );
  }
}

class ContactCard extends StatelessWidget {
  final VoidCallback onTap;

  const ContactCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      width: 350,
      padding: const EdgeInsets.all(16),
      title: const Text('Contact Information', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          _buildTableRow('Name', 'Muhammad Khairul Haziq bin Mohamad Khairi'),
          const SizedBox(height: 8),
          _buildTableRow('Student Number', '2023164629'),
          const SizedBox(height: 8),
          _buildTableRow('Group', 'RCDCS2515B'),
          const SizedBox(height: 8),
          _buildTableRow('Course', 'CS251'),
          const SizedBox(height: 8),
          _buildTableRow('Email', 'ihaziqkhairi@gmail.com'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: _buildTableRow(
              'GitHub',
              'Visit GitHub Repository',
              underline: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String label, String value, {bool underline = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 16), // Blank column
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: underline
                ? const TextStyle(decoration: TextDecoration.underline)
                : null,
          ),
        ),
      ],
    );
  }
}

class BuildCopyrightNotice extends StatelessWidget {
  const BuildCopyrightNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Copyright © 2024 Haziq Khairi. All rights reserved.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
      ),
    );
  }
}
