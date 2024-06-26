import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:watts_my_bill/pages/home.dart';
import 'package:watts_my_bill/pages/about.dart';
import 'package:watts_my_bill/utils/assets.dart';

void main() {
  runApp(const App());
}

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
            home: const MainScreen(),
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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabItems = [
    const HomePage(),
    const AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      body: _tabItems[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        backgroundColor: theme.colorScheme.popover,
        animationCurve: Curves.linear,
        selectedIndex: _selectedIndex,
        iconSize: 30,
        // showElevation: false, // use this to remove appBar's elevation
        onItemSelected: _onItemTapped,
        items: [
          FlashyTabBarItem(
            icon: Image.asset(
              Assets.wattsMyBillLogo,
              height: 30,
            ),
            title: const Text('Calculation'),
            activeColor: theme.colorScheme.primary,
            inactiveColor: theme.colorScheme.primary.withOpacity(0.4),
          ),
          FlashyTabBarItem(
            icon: SvgPicture.asset(
              Assets.personIcon,
              height: 20,
              width: 20,
              colorFilter:
                  ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
            ),
            title: const Text('About Me'),
            activeColor: theme.colorScheme.primary,
            inactiveColor: theme.colorScheme.primary.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}
