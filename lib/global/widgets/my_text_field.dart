import 'package:dozen_diamond/ZL_Register/constants/countryCodeFlags.dart';
import 'package:dozen_diamond/ZL_Register/models/mobile_number_codes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../global/constants/currency_constants.dart';
import 'custom_container.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  bool isForPhoneNumber = false;
  final bool autoFocus;
  final String labelText;
  final void Function(String) onChanged;
  final ValueChanged<MobileNumberCodeModel?>? onChangedForNumber;
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
  final bool? currencyFormat;
  List<TextInputFormatter>? textInputFormatters;
  final AutovalidateMode autovalidateMode;

  final MobileNumberCodeModel selectedCountryCode;
  final prefixText;

  MyTextField({
    required this.labelText,
    required this.onChanged,
    this.onChangedForNumber,
    this.isForPhoneNumber = false,
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
    this.selectedCountryCode = const MobileNumberCodeModel(
        countryCode: "+91",
        countryName: "India",
        countryFlagAssetPath: "lib/ZL_register/assets/images/flags1/ind.png"),
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: -7.5,
      horizontal: 10.0,
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
    this.textInputFormatters,
    this.currencyFormat = false,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.prefixText = "",
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  // List of country codes with flags

  late NumberFormat _currencyFormat;
  late CurrencyConstants _currencyConstantsProvider;
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
    _currencyConstantsProvider = Provider.of(context);
    _currencyFormat = NumberFormat.currency(
        locale: 'en_IN',
        symbol: _currencyConstantsProvider.currency,
        decimalDigits: 0);
    this.widget.borderColor ??= Colors.grey;
    this.widget.focusedBorderColor ??= Colors.white;
    return CustomContainer(
      width: this.widget.width,
      padding: 0,
      margin: this.widget.margin,
      // shadowColor: this.widget.borderColor,
      elevation: this.widget.elevation,
      borderColor: this.widget.isSimpleBorder! ? null : this.widget.borderColor,
      borderWidth: this.widget.borderWidth,
      borderRadius: this.widget.borderRadius,
      backgroundColor: this.widget.borderColor,
      child: Stack(
        children: [
          TextFormField(
            autovalidateMode: widget.autovalidateMode,
            focusNode: this.widget.focusNode,
            scrollPadding: this.widget.scrollPadding == null
                ? EdgeInsets.zero
                : this.widget.scrollPadding!,
            maxLength: this.widget.maxLength,
            showCursor: true,
            // autovalidateMode: AutovalidateMode.onUnfocus,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            onTap: this.widget.onTap,
            onFieldSubmitted: this.widget.onFieldSubmitted,
            controller: this.widget.controller,
            validator: this.widget.validator,
            initialValue: this.widget.defaultValue,
            textAlignVertical: TextAlignVertical.center,
            inputFormatters: this.widget.textInputFormatters ?? [],
            // inputFormatters: [
            //   CurrencyInputFormatter(), // Apply the custom currency formatter
            // ],
            autofocus: this.widget.autofocus,
            keyboardType: this.widget.keyboardType,
            onChanged: this.widget.onChanged,
            enabled: this.widget.isEnabled,
            obscureText:
                this.widget.isPasswordField ? !this._showPassword : false,

            style: this.widget.textStyle != null
                ? this.widget.textStyle
                : TextStyle(color: Colors.grey),
            cursorColor: Colors.grey,
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
              prefixText: this.widget.prefixText,
              prefixStyle: this.widget.textStyle,
              prefixIcon: widget.isForPhoneNumber
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<MobileNumberCodeModel>(
                          dropdownColor: Colors.black,
                          value: this.widget.selectedCountryCode,
                          items: mobileNumberCodes
                              .map((MobileNumberCodeModel model) {
                            return DropdownMenuItem<MobileNumberCodeModel>(
                              value: model,
                              child: Row(
                                children: [
                                  Image.asset(
                                    model.countryFlagAssetPath,
                                    width: 24,
                                    height: 16,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    model.countryCode,
                                    style: widget.textStyle ??
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: this.widget.onChangedForNumber,
                        ),
                      ),
                    )
                  : this.widget.showLeadingWidget
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: this.widget.showLeadingWidget
                                  ? this.widget.leading
                                  : null,
                            )
                          ],
                        )
                      : null,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
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
                                  color: Colors.white,
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
          (this.widget.currencyFormat == false)
              ? Container()
              : Positioned.fill(
                  child: IgnorePointer(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                        child: Container(
                          color: Color(0xFF15181F),
                          child: Text(
                              (this.widget.controller == null)
                                  ? ""
                                  : (this.widget.controller!.text == "")
                                      ? ""
                                      : "${_currencyFormat.format(double.parse(this.widget.controller!.text))}",
                              style: this.widget.textStyle ?? null),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
