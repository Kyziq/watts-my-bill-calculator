import 'package:toastification/toastification.dart';
import 'package:watts_my_bill/common/app_bar.dart';
import 'package:watts_my_bill/pages/about.dart';
import 'package:watts_my_bill/pages/calculate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:watts_my_bill/utils/constants.dart';

void main() {
  runApp(const App());
}

// Maps the routes to the specific widget page.
final routes = <String, WidgetBuilder>{
  Constants.homeRoute: (_) => const MainPage(),
  Constants.calculateRoute: (_) => const CalculatePage(),
  Constants.aboutRoute: (_) => const AboutPage()
};

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Solid(
      providers: [
        Provider<Signal<ThemeMode>>(create: () => Signal(ThemeMode.light)),
      ],
      builder: (context) {
        final themeMode = context.observe<ThemeMode>();
        return ToastificationWrapper(
          child: ShadApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            routes: routes,
            theme: ShadThemeData(
              brightness: Brightness.light,
              colorScheme: const ShadZincColorScheme.light(),
            ),
            darkTheme: ShadThemeData(
              brightness: Brightness.dark,
              colorScheme: const ShadZincColorScheme.dark(),
            ),
          ),
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        titleWidget: Text(Constants.appName),
        showThemeToggle: true,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShadButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Constants.calculateRoute),
              text: const Text('Calculate Now'),
            ),
            const SizedBox(width: 20),
            ShadButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Constants.aboutRoute),
              text: const Text('About Me'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
