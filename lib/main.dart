import 'package:toastification/toastification.dart';
import 'package:watts_my_bill/pages/about.dart';
import 'package:watts_my_bill/pages/home.dart';
import 'package:watts_my_bill/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const App());
}

// Maps the routes to the specific widget page.
final routes = <String, WidgetBuilder>{
  Constants.homeRoute: (_) => const HomePage(),
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
