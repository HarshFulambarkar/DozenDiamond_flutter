import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class threeDButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget? child;
  final double? padding;
  final EdgeInsets? paddingEdge;
  final double? height;
  final double? width;
  final double? borderWidth;
  final EdgeInsets? margin;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? shadowColor;
  final double? elevation;
  final bool isBorderSide;

  threeDButton({
    @required this.child,
    this.onTap,
    this.height = 50,
    this.width,
    this.margin,
    this.borderColor,
    this.shadowColor,
    this.padding = 0,
    this.paddingEdge,
    this.borderRadius = 5,
    this.backgroundColor = Colors.blue,
    this.elevation = 0,
    this.borderWidth = 1,
    this.isBorderSide = false,
  });

  @override
  State<threeDButton> createState() => _threeDButtonState();
}

class _threeDButtonState extends State<threeDButton> {
  static const double _shadowHeight = 4;
  double _position = 4;

  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    // final double _height = 64 - _shadowHeight;
    return Center(
      child: GestureDetector(
        onTap: widget.onTap,
        onTapUp: (_) async {
          print("onTapUp");
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            _position = 4;
          });
        },
        onTapDown: (_) {
          print("onTapDown");

          setState(() {
            _position = 0;
          });
        },
        onTapCancel: () {
          print("onTapCancel");
          setState(() {
            _position = 4;
          });
        },
        child: Container(
          height: this.widget.height! + _shadowHeight,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                    height: this.widget.height!,
                    // width: 200,
                    decoration: BoxDecoration(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: this.widget.child),
              ),
              AnimatedPositioned(
                curve: Curves.easeIn,
                bottom: _position,
                duration: Duration(milliseconds: 70),
                child: Container(
                  height: this.widget.height!,
                  // width: 200,
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: Center(child: this.widget.child
                      // child: Text(
                      //   'Click me!',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 22,
                      //   ),
                      // ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
