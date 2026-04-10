
import 'package:flutter/material.dart';

import 'custom_container.dart';


// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  final bool autoFocus;
  final String labelText;
  final void Function(String) onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final VoidCallback? trailingFunction;
  final String? defaultValue;
  final bool showTrailingWidget;
  final Widget? trailing;
  final bool showLeadingWidget;
  final Widget? leading;
  final bool autofocus;
  final bool isEnabled;
  final bool isLabelEnabled;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPasswordField;
  Color? borderColor;
  Color? focusedBorderColor;
  final double borderWidth;
  final double focusedBorderWidth;
  final double borderRadius;
  final String? hintText;
  final bool overrideHintText;
  final bool isFilled;
  final Color? fillColor;
  final double? width;
  final EdgeInsets? margin;
  final EdgeInsets? scrollPadding;

  final EdgeInsets contentPadding;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final double? elevation;
  final bool? isSimpleBorder;
  final int? maxLength;
  final String? counterText;
  final FocusNode? focusNode;
  final int? maxLine;


  MyTextField(
      {required this.labelText,
        required this.onChanged,
        this.onFieldSubmitted,
        this.onTap,
        this.hintText,
        this.trailingFunction,
        this.defaultValue,
        this.keyboardType,
        this.controller,
        this.validator,
        this.trailing,
        this.width,
        this.margin,
        this.overrideHintText = false,
        this.showTrailingWidget = true,
        this.autofocus = false,
        this.isPasswordField = false,
        this.borderColor,
        this.focusedBorderColor,
        this.borderWidth = 1,
        this.focusedBorderWidth = 2,
        this.borderRadius = 20,
        this.elevation = 2,
        this.autoFocus = true,
        this.isSimpleBorder = false,
        this.labelStyle,
        this.contentPadding = const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        this.fillColor = Colors.white,
        this.isFilled = false,
        this.hintTextStyle,
        this.textStyle,
        this.isEnabled = true,
        this.isLabelEnabled = true,
        this.showLeadingWidget = false,
        this.maxLength,
        this.counterText,
        this.leading,
        this.scrollPadding = EdgeInsets.zero,
        this.focusNode,
        this.maxLine,
      });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _showPassword;

  @override
  void initState() {
    _showPassword = !widget.isPasswordField;
    super.initState();
  }

  void toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    this.widget.borderColor ??= Colors.grey;
    this.widget.focusedBorderColor ??= Colors.black;
    return CustomContainer(
      width: this.widget.width,
      padding: 0,
      margin: this.widget.margin,
      shadowColor: this.widget.borderColor,
      elevation: this.widget.elevation,
      borderColor: this.widget.isSimpleBorder! ? null : this.widget.borderColor,
      borderWidth: this.widget.borderWidth,
      borderRadius: this.widget.borderRadius,
      backgroundColor: Colors.transparent,
      child: TextFormField(
        focusNode: this.widget.focusNode,
        scrollPadding: this.widget.scrollPadding == null ? EdgeInsets.zero : this.widget.scrollPadding!,
        maxLength:this.widget.maxLength,
        showCursor: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: this.widget.onTap,
        onFieldSubmitted: this.widget.onFieldSubmitted,
        controller: this.widget.controller,
        validator: this.widget.validator,
        initialValue: this.widget.defaultValue,
        textAlignVertical: TextAlignVertical.center,
        autofocus: this.widget.autofocus,
        keyboardType: this.widget.keyboardType,
        onChanged: this.widget.onChanged,
        enabled: this.widget.isEnabled,
        obscureText: this.widget.isPasswordField ? !this._showPassword : false,
        style: this.widget.textStyle != null
            ? this.widget.textStyle
            : TextStyle(color: Colors.grey),
        cursorColor: Colors.black,
        maxLines: this.widget.maxLine != null ? this.widget.maxLine : null,

        decoration: InputDecoration(
          counterText: this.widget.counterText,
          filled: this.widget.isFilled,
          fillColor: this.widget.fillColor,
          floatingLabelBehavior: this.widget.isLabelEnabled
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.never,
          hintText: '',
          labelStyle: this.widget.labelStyle != null
              ? this.widget.labelStyle
              : this.widget.textStyle != null
              ? this.widget.textStyle
              : TextStyle(color: Colors.white),
          contentPadding: this.widget.contentPadding,
          prefixIcon: this.widget.showLeadingWidget ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: this.widget.showLeadingWidget ? this.widget.leading : null,
              )

            ],
          ):null,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(this.widget.borderRadius),
          // ),
          border: InputBorder.none,
          enabledBorder:OutlineInputBorder(
            borderSide: BorderSide(
              color: this.widget.borderColor!,
              width: this.widget.borderWidth,
            ),
            borderRadius: BorderRadius.circular(this.widget.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: this.widget.focusedBorderColor!,
              width: this.widget.focusedBorderWidth,
            ),
            borderRadius: BorderRadius.circular(this.widget.borderRadius),
          ),
        ).copyWith(
          hintText: this.widget.overrideHintText
              ? this.widget.hintText
              : "${this.widget.labelText}",
          labelText: this.widget.labelText,
          suffixIcon: this.widget.showTrailingWidget
              ? this.widget.trailing == null
              ? Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: this.widget.isPasswordField
                ? IconButton(
              splashRadius: 1,
              color: Colors.black,
              icon: _showPassword
                  ? Icon(Icons.visibility, size: 25.0)
                  : Icon(Icons.visibility_off, size: 25.0),
              onPressed: toggleShowPassword,
            )
                : null,
          )
              : GestureDetector(
              onTap: this.widget.trailingFunction,
              child: this.widget.trailing)
              : null,
        ),
      ),
    );
  }
}