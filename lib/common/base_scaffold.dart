import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:watts_my_bill/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    required this.children,
    required this.appBarTitle,
    this.editable,
    this.showThemeToggle = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.wrapChildrenInScrollable = true,
    this.wrapSingleChildInColumn = true,
  });

  final List<Widget> children;
  final String appBarTitle;
  final List<Widget>? editable;
  final bool showThemeToggle;
  final CrossAxisAlignment crossAxisAlignment;
  final bool wrapChildrenInScrollable;
  final bool wrapSingleChildInColumn;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    Widget left = Center(
        child: children.length == 1 && !wrapSingleChildInColumn
            ? children[0]
            : Column(
                crossAxisAlignment: crossAxisAlignment,
                children: children.separatedBy(const SizedBox(height: 8)),
              ));

    if (wrapChildrenInScrollable) {
      left = SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: left,
      );
    }

    final Widget? right = editable == null
        ? null
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: editable!.separatedBy(const SizedBox(height: 8)),
              ),
            ),
          );

    return Scaffold(
      appBar: MyAppBar(title: appBarTitle, showThemeToggle: showThemeToggle),
      body: right != null
          ? MultiSplitViewTheme(
              data: MultiSplitViewThemeData(
                dividerPainter: _MyDividerPainter(
                  backgroundColor: isDarkMode ? Colors.white10 : Colors.black12,
                  highlightedBackgroundColor:
                      isDarkMode ? Colors.white24 : Colors.black26,
                ),
              ),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: MultiSplitView(
                  initialAreas: [
                    Area(
                      min: size.width / 2,
                      size: size.width * .7,
                      builder: (context, area) => left,
                    ),
                    Area(
                      min: size.width * .3,
                      builder: (context, area) => right,
                    ),
                  ],
                ),
              ),
            )
          : left,
    );
  }
}

class _MyDividerPainter extends DividerPainter {
  _MyDividerPainter({
    super.backgroundColor,
    super.highlightedBackgroundColor,
  });

  static const int backgroundKey = 0;

  /// Builds a tween map for animations.
  @override
  Map<int, Tween> buildTween() {
    final map = <int, Tween>{};
    if (animationEnabled &&
        backgroundColor != null &&
        highlightedBackgroundColor != null) {
      map[DividerPainter.backgroundKey] =
          ColorTween(begin: backgroundColor, end: highlightedBackgroundColor);
    }
    return map;
  }

  /// Paints the divider.
  @override
  void paint({
    required Axis dividerAxis,
    required bool resizable,
    required bool highlighted,
    required Canvas canvas,
    required Size dividerSize,
    required Map<int, dynamic> animatedValues,
  }) {
    var color = backgroundColor;
    var size = dividerSize;
    if (animationEnabled && animatedValues.containsKey(backgroundKey)) {
      color = animatedValues[backgroundKey] as Color?;
      size = Size(4, dividerSize.height);
    }

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color ?? Colors.transparent
      ..isAntiAlias = true;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }
}
