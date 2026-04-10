// class SubscriptionPlanData {
//   int? subscriptionPlanId;
//   String? planId;
//   String? subscriptionPlanName;
//   int? subscriptionPlanAmount;
//   String? subscriptionPlanDescription;
//   String? createdAt;
//   String? updatedAt;
//
//   SubscriptionPlanData(
//       {this.subscriptionPlanId,
//         this.planId,
//         this.subscriptionPlanName,
//         this.subscriptionPlanAmount,
//         this.subscriptionPlanDescription,
//         this.createdAt,
//         this.updatedAt});
//
//   SubscriptionPlanData.fromJson(Map<String, dynamic> json) {
//     subscriptionPlanId = json['subscription_plan_id'];
//     planId = json['subscription_id'];
//     subscriptionPlanName = json['subscription_plan_name'];
//     subscriptionPlanAmount = json['subscription_plan_amount'];
//     subscriptionPlanDescription = json['subscription_plan_description'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['subscription_plan_id'] = this.subscriptionPlanId;
//     data['subscription_id'] = this.planId;
//     data['subscription_plan_name'] = this.subscriptionPlanName;
//     data['subscription_plan_amount'] = this.subscriptionPlanAmount;
//     data['subscription_plan_description'] = this.subscriptionPlanDescription;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     return data;
//   }
// }

class SubscriptionPlanData {
  String? id;
  String? name;
  int? amountPaise;
  String? currency;
  String? period;
  String? description;
  int? interval;
  bool? isLoading = false;

  SubscriptionPlanData(
      {this.id,
        this.name,
        this.amountPaise,
        this.currency,
        this.period,
        this.description,
        this.interval,
        this.isLoading});

  SubscriptionPlanData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amountPaise = json['amount_paise'];
    currency = json['currency'];
    period = json['period'];
    description = json['description'];
    interval = json['interval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['amount_paise'] = this.amountPaise;
    data['currency'] = this.currency;
    data['period'] = this.period;
    data['description'] = this.description;
    data['interval'] = this.interval;
    return data;
  }
}