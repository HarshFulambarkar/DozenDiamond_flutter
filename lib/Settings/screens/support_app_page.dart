import 'package:flutter/material.dart';

class SupportAppPage extends StatelessWidget {
  final String title;
  final Function? updateIndex;
  const SupportAppPage(
      {super.key, required this.title, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavigationDrawerWidget(updateIndex: updateIndex),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF15181F),
        centerTitle: true,
        title: Text(title),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: const Color(0xFF15181F),
      body: Center(
        child: Text(
          "$title Page",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
