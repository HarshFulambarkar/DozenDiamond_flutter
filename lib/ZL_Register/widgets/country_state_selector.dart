import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/widgets/custom_container.dart';
import '../models/country_state_model.dart';

typedef OnSelection = void Function(
    String country,
    String state,
    City city,
    );

class CountryStateCityPicker extends StatefulWidget {
  final CountryStateCityData data;
  final OnSelection onSelection;

  const CountryStateCityPicker({
    Key? key,
    required this.data,
    required this.onSelection,
  }) : super(key: key);

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<CountryStateCityPicker> {
  String? _country;
  String? _state;
  City? _city;

  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    final countries = widget.data.countries;
    final states = _country != null
        ? widget.data.statesOf(_country!)
        : <String>[];
    final cities = (_country != null && _state != null)
        ? widget.data.citiesOf(_country!, _state!)
        : <City>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Country of legal residence",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 3),
          ],
        ),
        // Country selector
        SizedBox(
          height: 40,
          child: CustomContainer(
            padding: 0,
            borderRadius: 8,
            margin: EdgeInsets.zero,
            backgroundColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                  hint: Text(
                      'Select country',
                    style: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ?Colors.black:Colors.white,
                    ),
                  ),
                  value: _country,
                  menuMaxHeight: 200,
                  items: countries
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (c) {
                    if (c == null) return;
                    setState(() {
                      _country = c;
                      _state = null;
                      _city = null;
                    });
                  },
                ),
              ),
            ),
          ),
        ),

        // State selector
        if (states.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 15,
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "State of legal residence",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
              ),

              SizedBox(
                height: 40,
                child: CustomContainer(
                  borderRadius: 8,
                  padding: 0,
                  margin: EdgeInsets.zero,
                  backgroundColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                  borderColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: (themeProvider.defaultTheme)
                            ?Color(0xffCACAD3):Color(0xff2c2c31),
                        isExpanded: true,
                        hint: Text(
                            'Select State',
                          style: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ?Colors.black:Colors.white,
                          ),
                        ),
                        value: _state,
                        menuMaxHeight: 200,
                        items: states
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (s) {
                          if (s == null) return;
                          setState(() {
                            _state = s;
                            _city = null;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        // City selector
        // if (cities.isNotEmpty)
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: InputDecorator(
        //       decoration: const InputDecoration(
        //         labelText: 'City',
        //         border: OutlineInputBorder(),
        //         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        //       ),
        //       child: DropdownButtonHideUnderline(
        //         child: DropdownButton<City>(
        //           isExpanded: true,
        //           hint: const Text('Select city'),
        //           value: _city,
        //           menuMaxHeight: 200,
        //           items: cities
        //               .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
        //               .toList(),
        //           onChanged: (c) {
        //             if (c == null) return;
        //             setState(() => _city = c);
        //             widget.onSelection(_country!, _state!, c);
        //           },
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
