import 'package:flutter/material.dart';

class CustomSplashInkWell extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const CustomSplashInkWell(
      {required this.onTap, required this.child, Key? key})
      : super(key: key);

  @override
  _CustomSplashInkWellState createState() => _CustomSplashInkWellState();
}

class _CustomSplashInkWellState extends State<CustomSplashInkWell> {
  bool _isSplashVisible = false;

  void _handleTap() async {
    setState(() {
      _isSplashVisible = true;
    });

    // Wait for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSplashVisible = false;
    });

    // Trigger the onTap action
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        children: [
          widget.child,
          if (_isSplashVisible)
            Positioned.fill(
              child: Container(
                color: Colors.blue.withOpacity(0.3), // Splash effect color
              ),
            ),
        ],
      ),
    );
  }
}
