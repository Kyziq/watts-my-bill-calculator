import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showThemeToggle = true,
  }) : assert((title != null) ^ (titleWidget != null),
            'Must provide either title or titleWidget');

  final String? title;
  final Widget? titleWidget;
  final bool showThemeToggle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? Text(title!),
      centerTitle: true,
      actions: [
        if (showThemeToggle)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                context.update<ThemeMode>(
                  (value) => value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light,
                );
              },
              icon: SignalBuilder(
                signal: context.get<Signal<ThemeMode>>(),
                builder: (context, themeMode, child) {
                  return Icon(
                    themeMode == ThemeMode.light
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
