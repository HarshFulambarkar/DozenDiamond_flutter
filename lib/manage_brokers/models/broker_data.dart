import 'broker_dynamic_field_data.dart';

class BrokerData {
  int? brokerListId;
  String? brokerName;
  String? brokerImage;
  bool? isIntegratedIntoSystem;
  bool? isLoggedIn;
  String? apiEndPoints;
  List<BrokerDynamicFieldData>? fields;

  BrokerData({
    this.brokerListId,
    this.brokerName,
    this.brokerImage,
    this.isIntegratedIntoSystem,
    this.isLoggedIn,
    this.fields,
    this.apiEndPoints,
  });

  BrokerData.fromJson(Map<String, dynamic> json) {
    brokerListId = json['broker_list_id'];
    brokerName = json['broker_name'];
    brokerImage = json['broker_image'];
    isIntegratedIntoSystem = json['isIntegratedIntoSystem'];
    isLoggedIn = json['is_logged_in'];
    apiEndPoints = json['endpoint'];
    if (json['field_list'] != null) {
      fields = <BrokerDynamicFieldData>[];
      json['field_list'].forEach((v) {
        fields!.add(new BrokerDynamicFieldData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['broker_list_id'] = this.brokerListId;
    data['broker_name'] = this.brokerName;
    data['broker_image'] = this.brokerImage;
    data['isIntegratedIntoSystem'] = this.isIntegratedIntoSystem;
    data['is_logged_in'] = this.isLoggedIn;
    data['endpoint'] = this.apiEndPoints;
    if (this.fields != null) {
      data['field_list'] = this.fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'BrokerData(brokerListId: $brokerListId, brokerName: $brokerName, brokerImage: $brokerImage, isIntegratedIntoSystem: $isIntegratedIntoSystem, isLoggedIn: $isLoggedIn, apiEndPoints: $apiEndPoints, fields: $fields)';
  }
}