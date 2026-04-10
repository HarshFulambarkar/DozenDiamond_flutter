class BrokerDynamicFieldData {
  String? title;
  String? hint;
  String? key;
  String? fieldType; // text, number, dropdown, date etc.

  BrokerDynamicFieldData({this.title, this.hint, this.key, this.fieldType});

  BrokerDynamicFieldData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    hint = json['hint'];
    key = json['key'];
    fieldType = json['field_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['hint'] = this.title;
    data['key'] = this.key;
    data['field_type'] = this.title;
    return data;
  }
}