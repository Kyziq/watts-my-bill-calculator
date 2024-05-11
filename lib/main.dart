import 'package:watts_my_bill/common/app_bar.dart';
import 'package:watts_my_bill/pages/about.dart';
import 'package:watts_my_bill/pages/calculate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const App());
}

// Maps the routes to the specific widget page.
const String homeRoute = '/';
const String calculateRoute = '/calculate';
const String aboutRoute = '/about';
final routes = <String, WidgetBuilder>{
  homeRoute: (_) => const MainPage(),
  calculateRoute: (_) => const CalculatePage(),
  '/aboutRoute': (_) => const AboutPage()
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
        return ShadApp(
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
        titleWidget: Text('Watt\'s My Bill?'),
      ),
      body: Center(
        child: ShadButton(
          onPressed: () => Navigator.pushNamed(context, calculateRoute),
          text: const Text('Calculate'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
