import 'package:dozen_diamond/DD_Navigation/widgets/common_screen.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/my_text_field.dart';
import '../models/broker_dynamic_field_data.dart';
import '../stateManagement/manage_brokers_provider.dart';

class EnterBrokerDetailsScreen extends StatefulWidget {
  EnterBrokerDetailsScreen({super.key});

  @override
  State<EnterBrokerDetailsScreen> createState() =>
      _EnterBrokerDetailsScreenState();
}

class _EnterBrokerDetailsScreenState extends State<EnterBrokerDetailsScreen> {
  late NavigationProvider navigationProvider;

  late ManageBrokersProvider manageBrokersProvider;

  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
  }

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      manageBrokersProvider = Provider.of<ManageBrokersProvider>(
        context,
        listen: false,
      );

      for (var field in manageBrokersProvider.selectedBrokerFields) {
        controllers[field.key!] = TextEditingController();
      }

      _initialized = true;
    }
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Map<String, dynamic> collectFormData() {
    final Map<String, dynamic> data = {};

    controllers.forEach((key, controller) {
      data[key] = controller.text;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    manageBrokersProvider = Provider.of<ManageBrokersProvider>(
      context,
      listen: true,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: screenWidth == 0 ? null : screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 45),

                      SizedBox(height: 10),

                      // SizedBox(
                      //   height: AppBar().preferredSize.height * 1.5,
                      // ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Row(
                          children: [
                            Image.network(
                              manageBrokersProvider
                                      .selectedBroker
                                      .brokerImage ??
                                  "",
                              height: 35,
                              width: 35,
                              errorBuilder: (context, error, s) {
                                return Icon(Icons.image, size: 35);
                              },
                            ),

                            // Image.asset(
                            //   manageBrokersProvider
                            //           .selectedBroker
                            //           .brokerImage ??
                            //       "",
                            //   height: 35,
                            //   width: 35,
                            // ),
                            SizedBox(width: 10),

                            Text(
                              manageBrokersProvider.selectedBroker.brokerName ??
                                  "",
                              style: TextStyle(
                                fontSize: 25,
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      buildFieldsSection(context),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: const BorderSide(color: Color(0xFF0099CC)),
                            ),
                            onPressed: () async {
                              final body = collectFormData();
                              var value = await manageBrokersProvider.doBrokerLogin(
                                manageBrokersProvider
                                        .selectedBroker
                                        .apiEndPoints ??
                                    "",
                                body,
                              );
                              if (value) {
                                navigationProvider.selectedIndex = 12;
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => CommonScreen(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                // Fluttertoast.showToast(msg: "Something When Wrong");
                              }
                            },
                            child: (manageBrokersProvider.buttonLoading)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                      bottom: 8,
                                      top: 8.0,
                                    ),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Save Details',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xFFffffff)),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              CustomHomeAppBarWithProviderNew(
                backButton: true,
                widthOfWidget: screenWidth,
                isForPop:
                    true, //these leadingAction button is not working, I have tired making it work, but it isn't.
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFieldsSection(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: manageBrokersProvider.selectedBrokerFields.length,
        padding: const EdgeInsets.only(left: 20, right: 20.0),
        itemBuilder: (context, index) {
          final field = manageBrokersProvider.selectedBrokerFields[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  field.title ?? "",
                  style: TextStyle(color: Color(0xFFffffff), fontSize: 18),
                ),
              ),

              SizedBox(height: 5),

              _buildField(field),

              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildField(BrokerDynamicFieldData field) {
    switch (field.fieldType) {
      case "text":
        return _textField(field);
      // case "number":
      //   return _numberField(field);
      // case "email":
      //   return _emailField(field);
      // case "date":
      //   return _dateField(field);
      default:
        return _textField(field);
    }
  }

  Widget _textField(BrokerDynamicFieldData field) {
    return MyTextField(
      controller: controllers[field.key],
      borderRadius: 5,

      currencyFormat: false,
      isFilled: true,
      elevation: 0,
      isLabelEnabled: false,
      borderWidth: 1,
      fillColor: Color(0xff2c2c31), // Colors.transparent,
      contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),

      onChanged: (value) {},
      borderColor: Colors.white,
      labelText: field.hint ?? "",
      hintText: field.hint ?? "",
      counterText: "",

      overrideHintText: true,

      focusedBorderColor: Colors.white,
      isPasswordField: false,

      isEnabled: true,

      // showLeadingWidget: true,
      validator: (value) {},
    );
  }
}
