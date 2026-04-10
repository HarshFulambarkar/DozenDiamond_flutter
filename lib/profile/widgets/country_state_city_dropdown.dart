import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/ZL_Register/models/country_state_model.dart';
import 'package:dozen_diamond/create_ladder_easy/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../global/functions/screenWidthRecoginzer.dart';

class CountryDropdown extends StatelessWidget {
  final String? value;
  final Function(String?) onChanged;
  final CountryStateCityData data;

  const CountryDropdown({
    super.key,
    required this.data,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final countries = data.countries;
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    double screenWidth = screenWidthRecognizer(context);
    return SizedBox(
      height: 33,
      width: screenWidth * 0.5,
      child: CustomContainer(
        padding: 0,
        borderRadius: 8,
        margin: EdgeInsets.zero,
        backgroundColor: (themeProvider.defaultTheme)
            ? Color(0xffCACAD3)
            : Color(0xff2c2c31),
        borderColor: (themeProvider.defaultTheme)
            ? Color(0xffCACAD3)
            : Color(0xff2c2c31),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: (themeProvider.defaultTheme)
                  ? Color(0xffCACAD3)
                  : Color(0xff2c2c31),
              hint: Text(
                'Select country',
                style: TextStyle(
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              value: value,
              menuMaxHeight: 200,
              items: countries
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}

class StateDropdown extends StatelessWidget {
  final String? selectedCountry;
  final String? value;
  final Function(String?) onChanged;
  final CountryStateCityData data;

  const StateDropdown({
    super.key,
    required this.data,
    required this.selectedCountry,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedCountry == null) return const SizedBox();

    final states = data.statesOf(selectedCountry!);
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    double screenWidth = screenWidthRecognizer(context);
    return SizedBox(
      height: 33,
      width: screenWidth * 0.5,

      child: CustomContainer(
        padding: 0,
        borderRadius: 8,
        margin: EdgeInsets.zero,
        backgroundColor: (themeProvider.defaultTheme)
            ? Color(0xffCACAD3)
            : Color(0xff2c2c31),
        borderColor: (themeProvider.defaultTheme)
            ? Color(0xffCACAD3)
            : Color(0xff2c2c31),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: (themeProvider.defaultTheme)
                  ? Color(0xffCACAD3)
                  : Color(0xff2c2c31),
              hint: Text(
                'Select state',
                style: TextStyle(
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              value: value,
              menuMaxHeight: 200,
              items: states
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}

class CityDropdown extends StatelessWidget {
  final String? selectedCountry;
  final String? selectedState;
  final City? value;
  final Function(City?) onChanged;
  final CountryStateCityData data;

  const CityDropdown({
    super.key,
    required this.data,
    required this.selectedCountry,
    required this.selectedState,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedCountry == null || selectedState == null) {
      return const SizedBox();
    }

    final cities = data.citiesOf(selectedCountry!, selectedState!);
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    double screenWidth = screenWidthRecognizer(context);
    return SizedBox(
      height: 33,
      width: screenWidth * 0.5,

      child: CustomContainer(
        padding: 0,
        borderRadius: 8,
        margin: EdgeInsets.zero,
        backgroundColor: (themeProvider.defaultTheme)
            ? Color(0xffCACAD3)
            : Color(0xff2c2c31),
        borderColor: (themeProvider.defaultTheme)
            ? Color(0xffCACAD3)
            : Color(0xff2c2c31),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<City>(
              isExpanded: true,
              dropdownColor: (themeProvider.defaultTheme)
                  ? Color(0xffCACAD3)
                  : Color(0xff2c2c31),
              hint: Text(
                'Select City',
                style: TextStyle(
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              value: value,
              menuMaxHeight: 200,
              items: cities
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}