import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A function that builds a widget with a [ScrollController].
typedef ScrollRestorationBuilder = Widget Function(
  BuildContext,
  ScrollController,
);

/// {@template ScrollRestoration}
/// Wrap any scrollable widget to remember its scroll offset.
/// {@endtemplate}
class ScrollRestoration extends StatefulWidget {
  /// {@macro ScrollRestoration}
  const ScrollRestoration({
    super.key,
    required this.id,
    required this.builder,
  });

  /// Unique identifier for this scrollable.
  /// Used as the [SharedPreferences] key.
  final String id;

  /// Build your scrollable, passing in the provided [ScrollController].
  final ScrollRestorationBuilder builder;

  @override
  ScrollRestorationState createState() => ScrollRestorationState();
}

/// State for [ScrollRestoration].
class ScrollRestorationState extends State<ScrollRestoration> {
  late final ScrollController _controller;
  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final double savedOffset = _prefs.getDouble(widget.id) ?? 0.0;

    // Wait for first frame so controller has a valid position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients || _controller.positions.isEmpty) {
        return;
      }

      final double maxScroll = _controller.position.maxScrollExtent;
      final double offset = savedOffset.clamp(0.0, maxScroll);
      _controller.jumpTo(offset);

      // Start listening to scroll end events after initialization
      _controller.position.isScrollingNotifier.addListener(_saveOffset);
    });
  }

  void _saveOffset() {
    // Only save when scrolling stops
    if (!_controller.hasClients || !_controller.position.hasContentDimensions) {
      return;
    }
    _prefs.setDouble(widget.id, _controller.offset);
  }

  @override
  void dispose() {
    if (_controller.hasClients) {
      _controller.position.isScrollingNotifier.removeListener(_saveOffset);
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }
}
