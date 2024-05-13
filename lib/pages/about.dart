import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      appBarTitle: 'About Me',
      wrapChildrenInScrollable:
          false, // Now handled individually within children
      wrapSingleChildInColumn: false,
      children: [
        Expanded(
          // This will take all available space pushing the copyright to bottom
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const BuildProfilePicture(),
                const SizedBox(height: 20),
                // BuildProfileDetails(),
                const BuildContactInfo(),
                const SizedBox(height: 10),
                BuildGitHubLink(onTap: _launchUrl),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20), // Adds space at the bottom
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

class BuildContactInfo extends StatelessWidget {
  const BuildContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Assets.emailIcon,
          height: 20,
          width: 20,
        ),
        const SizedBox(width: 8),
        const Text('ihaziqkhairi@gmail.com'),
      ],
    );
  }
}

class BuildGitHubLink extends StatelessWidget {
  final VoidCallback onTap;

  const BuildGitHubLink({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.githubIcon,
            height: 20,
            width: 20,
          ),
          const SizedBox(width: 8),
          const Text('Visit GitHub Repository',
              style: TextStyle(decoration: TextDecoration.underline)),
        ],
      ),
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
        color: Colors.black87,
        fontSize: 12,
      ),
    );
  }
}
