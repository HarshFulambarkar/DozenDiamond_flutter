import '../../welcome_screens/models/welcome_screen_data.dart';

class AppConfigResponse {
  bool? status;
  String? message;
  Data? data;

  AppConfigResponse({this.status, this.message, this.data});

  AppConfigResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? appName;
  String? versionFrontend;
  String? versionBackend;
  String? versionServer;
  Logo? logo;
  bool? subscriptionEnable;
  bool? realTradingEnable;

  bool? addFundsEnableDrawer;
  bool? createLadderEnableDrawer;
  bool? tradeEnableDrawer;
  bool? analyticsEnableDrawer;
  bool? dematInfoEnableDrawer;
  bool? monitorEnableDrawer;
  bool? strategiesEnableDrawer;
  bool? settingsEnableDrawer;
  bool? resetCompleteSimulationEnableDrawer;
  bool? logoutEnableDrawer;

  bool? themeEnable;
  bool? tradingOptionEnable;
  bool? countryOptionEnable;
  bool? ladderOptionEnable;
  bool? manageBrokersEnable;
  bool? contactCustomerSupportEnable;
  bool? formulaEnable;
  bool? kycEnable;

  bool? addFundsEnableBottomNavBar;
  bool? createLadderEnableBottomNavBar;
  bool? watchlistEnableBottomNavBar;
  bool? tradeEnableBottomNavBar;
  bool? analyticsEnableBottomNavBar;

  Developer? developer;
  Features? features;
  ApiConfig? apiConfig;
  BuildInfo? buildInfo;

  bool? androidForceUpdate;
  int? androidBuildNumber;
  String? androidUpdateUrl;
  bool? iosForceUpdate;
  int? iosBuildNumber;
  String? iosUpdateUrl;

  List<WelcomeScreenData>? welcomeScreenData;

  UpdateMessage? updateMessageOutSide;
  UpdateMessage? updateMessageInSide;

  Data({
    this.appName,
    this.versionFrontend,
    this.versionBackend,
    this.versionServer,
    this.logo,
    this.subscriptionEnable = true,
    this.realTradingEnable = true,
    this.addFundsEnableDrawer = true,
    this.createLadderEnableDrawer = true,
    this.tradeEnableDrawer = true,
    this.analyticsEnableDrawer = true,
    this.dematInfoEnableDrawer = true,
    this.monitorEnableDrawer = true,
    this.strategiesEnableDrawer = true,
    this.settingsEnableDrawer = true,
    this.resetCompleteSimulationEnableDrawer = true,
    this.logoutEnableDrawer = true,
    this.kycEnable = true,
    this.themeEnable = true,
    this.tradingOptionEnable = true,
    this.countryOptionEnable = true,
    this.ladderOptionEnable = true,
    this.manageBrokersEnable = true,
    this.contactCustomerSupportEnable = true,
    this.formulaEnable = true,
    this.addFundsEnableBottomNavBar = true,
    this.createLadderEnableBottomNavBar = true,
    this.watchlistEnableBottomNavBar = true,
    this.tradeEnableBottomNavBar = true,
    this.analyticsEnableBottomNavBar = true,
    this.developer,
    this.features,
    this.apiConfig,
    this.buildInfo,
    this.androidForceUpdate,
    this.androidBuildNumber,
    this.androidUpdateUrl,
    this.iosForceUpdate,
    this.iosBuildNumber,
    this.iosUpdateUrl,
    this.welcomeScreenData,
    this.updateMessageOutSide,
    this.updateMessageInSide,
  });

  Data.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    versionFrontend = json['version_frontend'];
    versionBackend = json['version_backend'];
    versionServer = json['version_server'];
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
    subscriptionEnable = json['subscription_enable'] ?? true;
    realTradingEnable = json['real_trading_enable'] ?? true;

    addFundsEnableDrawer = json['add_funds_enable_drawer'] ?? true;
    createLadderEnableDrawer = json['create_ladder_enable_drawer'] ?? true;
    tradeEnableDrawer = json['trade_enable_drawer'] ?? true;
    analyticsEnableDrawer = json['analytics_enable_drawer'] ?? true;
    dematInfoEnableDrawer = json['demat_info_enable_drawer'] ?? true;
    monitorEnableDrawer = json['monitor_enable_drawer'] ?? true;
    strategiesEnableDrawer = json['strategies_enable_drawer'] ?? true;
    settingsEnableDrawer = json['settings_enable_drawer'] ?? true;
    resetCompleteSimulationEnableDrawer =
        json['reset_complete_simulation_enable_drawer'] ?? true;
    logoutEnableDrawer = json['logout_enable_drawer'] ?? true;

    themeEnable = json['theme_enable'] ?? true;
    tradingOptionEnable = json['trading_option_enable'] ?? true;
    countryOptionEnable = json['country_option_enable'] ?? true;
    ladderOptionEnable = json['ladder_option_enable'] ?? true;
    manageBrokersEnable = json['manage_brokers_enable'] ?? true;
    contactCustomerSupportEnable =
        json['contact_customer_support_enable'] ?? true;
    formulaEnable = json['formula_enable'] ?? true;
    kycEnable = json['kyc_enable'] ?? true;

    addFundsEnableBottomNavBar = json['add_funds_bottom_nav_bar'] ?? true;
    createLadderEnableBottomNavBar =
        json['create_ladder_enable_bottom_nav_bar'] ?? true;
    watchlistEnableBottomNavBar =
        json['watchlist_enable_bottom_nav_bar'] ?? true;
    tradeEnableBottomNavBar = json['trade_enable_bottom_nav_bar'] ?? true;
    analyticsEnableBottomNavBar =
        json['analytics_enable_bottom_nav_bar'] ?? true;

    developer = json['developer'] != null
        ? new Developer.fromJson(json['developer'])
        : null;
    features = json['features'] != null
        ? new Features.fromJson(json['features'])
        : null;
    apiConfig = json['api_config'] != null
        ? new ApiConfig.fromJson(json['api_config'])
        : null;
    buildInfo = json['build_info'] != null
        ? new BuildInfo.fromJson(json['build_info'])
        : null;

    androidForceUpdate = json['android_force_update'] ?? true;
    androidBuildNumber = json['android_build_number'] ?? 0;
    androidUpdateUrl = json['android_update_url'] ?? "";
    iosForceUpdate = json['ios_force_update'] ?? true;
    iosBuildNumber = json['ios_build_number'] ?? 0;
    iosUpdateUrl = json['ios_update_url'] ?? "";

    if (json['welcome_screens_data'] != null) {
      welcomeScreenData = <WelcomeScreenData>[];
      json['welcome_screens_data'].forEach((v) {
        welcomeScreenData!.add(new WelcomeScreenData().fromJson(v));
      });
    }
    // welcomeScreenData = json['welcome_screens_data'] != null
    //     ? new WelcomeScreenData.fromJson(json['welcome_screens_data'])
    //     : null;

    updateMessageOutSide = json['update_message_out_side'] != null
        ? new UpdateMessage.fromJson(json['update_message_out_side'])
        : null;
    updateMessageInSide = json['update_message_in_side'] != null
        ? new UpdateMessage.fromJson(json['update_message_in_side'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['version_frontend'] = this.versionFrontend;
    data['version_backend'] = this.versionBackend;
    data['version_server'] = this.versionServer;
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    data['subscription_enable'] = this.subscriptionEnable;
    data['real_trading_enable'] = this.realTradingEnable;

    data['add_funds_enable_drawer'] = this.addFundsEnableDrawer;
    data['create_ladder_enable_drawer'] = this.createLadderEnableDrawer;
    data['trade_enable_drawer'] = this.tradeEnableDrawer;
    data['analytics_enable_drawer'] = this.analyticsEnableDrawer;
    data['demat_info_enable_drawer'] = this.dematInfoEnableDrawer;
    data['monitor_enable_drawer'] = this.monitorEnableDrawer;
    data['strategies_enable_drawer'] = this.strategiesEnableDrawer;
    data['settings_enable_drawer'] = this.settingsEnableDrawer;
    data['reset_complete_simulation_enable_drawer'] =
        this.resetCompleteSimulationEnableDrawer;
    data['logout_enable_drawer'] = this.logoutEnableDrawer;

    data['theme_enable'] = this.themeEnable;
    data['trading_option_enable'] = this.tradingOptionEnable;
    data['country_option_enable'] = this.countryOptionEnable;
    data['ladder_option_enable'] = this.ladderOptionEnable;
    data['manage_brokers_enable'] = this.manageBrokersEnable;
    data['contact_customer_support_enable'] = this.contactCustomerSupportEnable;
    data['formula_enable'] = this.formulaEnable;
    data['kyc_enable'] = this.kycEnable;

    data['add_funds_bottom_nav_bar'] = this.addFundsEnableBottomNavBar;
    data['create_ladder_enable_bottom_nav_bar'] =
        this.createLadderEnableBottomNavBar;
    data['watchlist_enable_bottom_nav_bar'] = this.watchlistEnableBottomNavBar;
    data['trade_enable_bottom_nav_bar'] = this.tradeEnableBottomNavBar;
    data['analytics_enable_bottom_nav_bar'] = this.analyticsEnableBottomNavBar;

    if (this.developer != null) {
      data['developer'] = this.developer!.toJson();
    }
    if (this.features != null) {
      data['features'] = this.features!.toJson();
    }
    if (this.apiConfig != null) {
      data['api_config'] = this.apiConfig!.toJson();
    }
    if (this.buildInfo != null) {
      data['build_info'] = this.buildInfo!.toJson();
    }

    data['android_force_update'] = this.androidForceUpdate;
    data['android_build_number'] = this.androidBuildNumber;
    data['android_update_url'] = this.androidUpdateUrl;
    data['ios_force_update'] = this.iosForceUpdate;
    data['ios_build_number'] = this.iosBuildNumber;
    data['ios_update_url'] = this.iosUpdateUrl;

    if (this.welcomeScreenData != null) {
      data['welcome_screens_data'] =
          this.welcomeScreenData!.map((v) => v.toJson()).toList();
    }

    // if (this.welcomeScreenData != null) {
    //   data['welcome_screens_data'] = this.welcomeScreenData!.toJson();
    // }
    if (this.updateMessageOutSide != null) {
      data['update_message_out_side'] = this.updateMessageOutSide!.toJson();
    }
    if (this.updateMessageInSide != null) {
      data['update_message_in_side'] = this.updateMessageInSide!.toJson();
    }
    return data;
  }
}

class Logo {
  String? koshUrl;
  String? ddUrl;

  Logo({this.koshUrl, this.ddUrl});

  Logo.fromJson(Map<String, dynamic> json) {
    koshUrl = json['kosh_url'];
    ddUrl = json['dd_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kosh_url'] = this.koshUrl;
    data['dd_url'] = this.ddUrl;
    return data;
  }
}

class Developer {
  String? name;
  String? contactEmail;
  String? website;

  Developer({this.name, this.contactEmail, this.website});

  Developer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contactEmail = json['contact_email'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contact_email'] = this.contactEmail;
    data['website'] = this.website;
    return data;
  }
}

class Features {
  bool? darkMode;
  bool? offlineSupport;
  List<String>? multiLanguage;

  Features({this.darkMode, this.offlineSupport, this.multiLanguage});

  Features.fromJson(Map<String, dynamic> json) {
    darkMode = json['dark_mode'];
    offlineSupport = json['offline_support'];
    multiLanguage = json['multi_language'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dark_mode'] = this.darkMode;
    data['offline_support'] = this.offlineSupport;
    data['multi_language'] = this.multiLanguage;
    return data;
  }
}

class ApiConfig {
  String? baseUrl;
  int? timeout;

  ApiConfig({this.baseUrl, this.timeout});

  ApiConfig.fromJson(Map<String, dynamic> json) {
    baseUrl = json['base_url'];
    timeout = json['timeout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_url'] = this.baseUrl;
    data['timeout'] = this.timeout;
    return data;
  }
}

class BuildInfo {
  String? buildDate;
  int? buildNumber;

  BuildInfo({this.buildDate, this.buildNumber});

  BuildInfo.fromJson(Map<String, dynamic> json) {
    buildDate = json['build_date'];
    buildNumber = json['build_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['build_date'] = this.buildDate;
    data['build_number'] = this.buildNumber;
    return data;
  }
}

class UpdateMessage {
  Message? android;
  Message? ios;
  Message? web;

  UpdateMessage({this.android, this.ios, this.web});

  UpdateMessage.fromJson(Map<String, dynamic> json) {
    android =
    json['android'] != null ? new Message.fromJson(json['android']) : null;
    ios = json['ios'] != null ? new Message.fromJson(json['ios']) : null;
    web = json['web'] != null ? new Message.fromJson(json['web']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.android != null) {
      data['android'] = this.android!.toJson();
    }
    if (this.ios != null) {
      data['ios'] = this.ios!.toJson();
    }
    if (this.web != null) {
      data['web'] = this.web!.toJson();
    }
    return data;
  }
}

class Message {
  int? minBuildNumber;
  String? message;
  String? subMessage;

  Message({this.minBuildNumber, this.message, this.subMessage});

  Message.fromJson(Map<String, dynamic> json) {
    minBuildNumber = json['min_build_number'];
    message = json['message'];
    subMessage = json['sub_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min_build_number'] = this.minBuildNumber;
    data['message'] = this.message;
    data['sub_message'] = this.subMessage;
    return data;
  }
}
