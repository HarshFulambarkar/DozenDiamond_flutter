import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/manage_brokers/stateManagement/manage_brokers_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/constants/custom_colors_light.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../models/broker_data.dart';
import '../zerodha/screens/enter_zerodha_details_screen.dart';
import 'enter_broker_details_screen.dart';

class BrokerList extends StatefulWidget {
  @override
  State<BrokerList> createState() => _BrokerListState();
}

class _BrokerListState extends State<BrokerList> {
  late ManageBrokersProvider manageBrokersProvider;
  late CurrencyConstants currencyConstants;

  @override
  void initState() {
    super.initState();

    manageBrokersProvider = Provider.of<ManageBrokersProvider>(
      context,
      listen: false,
    );
    manageBrokersProvider.fetchBrokers();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);

    manageBrokersProvider = Provider.of<ManageBrokersProvider>(context, listen: true);
    currencyConstants = Provider.of<CurrencyConstants>(context, listen: true);

    return Scaffold(
      backgroundColor: const Color(0xFF15181F), // 🔥 FIX: Set explicit background color
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              // 🔥 FIX: Add a background container
              Container(
                width: double.infinity,
                child: Center(
                  child: Container(
                    width: screenWidth == 0 ? null : screenWidth,
                    child: (currencyConstants.isCountryUsa)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: Center(
                              child: Text(
                                "No Broker Found",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 45),
                              Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                                child: Text(
                                  "Brokers",
                                  style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              brokerSearchBar(),
                              const SizedBox(height: 10),
                              ...(manageBrokersProvider
                                          .searchBrokerTextEditingController
                                          .text ==
                                      "")
                                  ? manageBrokersProvider.brokerList
                                        .map(
                                          (analysisType) =>
                                              analysisButton(analysisType, context),
                                        )
                                        .toList()
                                  : manageBrokersProvider.searchedBrokerList
                                        .map(
                                          (analysisType) =>
                                              analysisButton(analysisType, context),
                                        )
                                        .toList(),
                            ],
                          ),
                  ),
                ),
              ),
              CustomHomeAppBarWithProviderNew(
                backButton: true,
                widthOfWidget: screenWidth,
                isForPop: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget analysisButton(BrokerData broker, BuildContext context) {
    final bool isIntegrated = broker.isIntegratedIntoSystem ?? false;
    final bool isLoggedIn = broker.isLoggedIn ?? false;
    
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8.0, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade700, // 🔥 FIX: Use grey instead of white
            ),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          hoverColor: Colors.transparent,
          onTap: () {
            if (isIntegrated) {
              manageBrokersProvider.selectedBroker = broker;
              manageBrokersProvider.selectedBrokerFields = broker.fields ?? [];

              if (broker.brokerName != "Zerodha") {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EnterBrokerDetailsScreen()),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EnterZerodhaDetailsScreen()),
                );
              }
            } else {
              Fluttertoast.showToast(msg: 'This broker will unlock soon!');
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
            child: Row(
              children: [
                // 🔥 FIX: Remove ColorFiltered or use it conditionally
                isIntegrated
                    ? Image.network(
                        broker.brokerImage ?? "",
                        height: 30,
                        width: 30,
                        errorBuilder: (context, error, s) {
                          return const Icon(Icons.image, size: 30, color: Colors.white);
                        },
                      )
                    : Opacity(
                        opacity: 0.5,
                        child: Image.network(
                          broker.brokerImage ?? "",
                          height: 30,
                          width: 30,
                          errorBuilder: (context, error, s) {
                            return const Icon(Icons.image, size: 30, color: Colors.grey);
                          },
                        ),
                      ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    broker.brokerName ?? "-",
                    style: TextStyle(
                      color: isIntegrated ? Colors.white : Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (isLoggedIn)
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(msg: 'Logout successfully');
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.blue.shade300,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: isIntegrated ? Colors.blue : Colors.grey.shade500,
                    size: 15,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget brokerSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 8.0),
      child: TextField(
        onChanged: (value) {
          manageBrokersProvider.searchBrokers(value);
        },
        textInputAction: TextInputAction.search,
        controller: manageBrokersProvider.searchBrokerTextEditingController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: 'Search Broker',
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}