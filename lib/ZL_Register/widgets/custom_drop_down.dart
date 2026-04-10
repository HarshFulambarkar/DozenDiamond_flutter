import 'package:flutter/material.dart';
import 'package:dozen_diamond/ZL_Register/models/mobile_number_codes_model.dart';

class MobileNumberCodeDropDown extends StatelessWidget {
  final List<MobileNumberCodeModel> options;
  final MobileNumberCodeModel? selectedValue;
  final void Function(MobileNumberCodeModel?)? onChanged;
  final String hintText;
  const MobileNumberCodeDropDown({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(BorderSide(
          color: Colors.grey[500] ?? Colors.grey,
        )),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: Colors.black,
          // isDense: true,
          hint: Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Row(
              children: [
                const Icon(
                  Icons.flag,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  hintText,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          isExpanded: true,
          value: selectedValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: options.map((item) {
            return DropdownMenuItem(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FittedBox(
                            child: Text(
                              item.countryCode,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              softWrap: true,
                            ),
                          ),
                          const SizedBox(
                            width: 17,
                          ),
                          FittedBox(
                            child: Text(
                              item.countryName,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        item.countryFlagAssetPath,
                        width: 30,
                      ),
                    ],
                  ),
                )
                // ListTile(
                //   leading: Text(
                //     item.countryCode,
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   title: Text(
                //     item.countryName,
                //     style: const TextStyle(
                //       color: Colors.black,
                //     ),
                //   ),
                //   trailing: Image.asset(
                //     item.countryFlagAssetPath,
                //     width: 30,
                //   ),
                // ),
                );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
