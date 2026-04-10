class SubscribedData {
  String? planName;
  String? description;
  String? nextBillingDate;
  String? duration;
  int? amount;
  String? status;

  SubscribedData(
      {this.planName,
        this.description,
        this.nextBillingDate,
        this.duration,
        this.amount,
        this.status});

  SubscribedData.fromJson(Map<String, dynamic> json) {
    planName = json['plan_name'];
    description = json['description'];
    nextBillingDate = json['next_billing_date'];
    duration = json['duration'];
    amount = json['amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_name'] = this.planName;
    data['description'] = this.description;
    data['next_billing_date'] = this.nextBillingDate;
    data['duration'] = this.duration;
    data['amount'] = this.amount;
    data['status'] = this.status;
    return data;
  }
}