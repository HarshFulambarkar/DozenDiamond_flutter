import 'package:dozen_diamond/create_ladder_detailed/models/ladder_creation_screen1.dart';
import 'package:dozen_diamond/create_ladder_detailed/models/ladder_creation_screen2.dart';
import 'package:dozen_diamond/create_ladder_detailed/models/ladder_creation_screen3.dart';

class LadderCreationScreenBundle {
  List<LadderCreationScreen1> screen1List;
  List<LadderCreationScreen2> screen2List;
  List<LadderCreationScreen3> screen3List;

  LadderCreationScreenBundle({
    required this.screen1List,
    required this.screen2List,
    required this.screen3List,
  });
}
