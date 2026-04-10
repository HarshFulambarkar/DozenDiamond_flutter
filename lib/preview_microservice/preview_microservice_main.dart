import 'package:dozen_diamond/preview_microservice/screens/preview_microservice_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CreateLadderEasyMain extends StatefulWidget {
  const CreateLadderEasyMain({Key? key}) : super(key: key);

  @override
  State<CreateLadderEasyMain> createState() => _CreateLadderEasyMainState();
}

class _CreateLadderEasyMainState extends State<CreateLadderEasyMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return PreviewMicroserviceScreen();

  }
}
