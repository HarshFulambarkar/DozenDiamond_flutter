import 'package:dozen_diamond/global/constants/assets_string.dart';
import 'package:dozen_diamond/global/constants/custom_colors_light.dart';
import 'package:dozen_diamond/global/constants/data_string.dart';

class AppModule {
  DataStrings get dataStrings => DataStrings();

  AssetStrings get assetsStrings => AssetStrings();

  CustomColorsLight get customColors => CustomColorsLight();

  // PreferredSizeWidget appBar(BuildContext context) =>
  //     CustomAppBar().appBar(context);
}
