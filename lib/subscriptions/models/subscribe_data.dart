class SubscribeData {
  String? id;
  String? entity;
  String? planId;
  String? status;
  Null? currentStart;
  Null? currentEnd;
  Null? endedAt;
  int? quantity;
  List<Null>? notes;
  Null? chargeAt;
  Null? startAt;
  Null? endAt;
  int? authAttempts;
  int? totalCount;
  int? paidCount;
  bool? customerNotify;
  int? createdAt;
  Null? expireBy;
  String? shortUrl;
  bool? hasScheduledChanges;
  Null? changeScheduledAt;
  String? source;
  int? remainingCount;

  SubscribeData(
      {this.id,
        this.entity,
        this.planId,
        this.status,
        this.currentStart,
        this.currentEnd,
        this.endedAt,
        this.quantity,
        this.notes,
        this.chargeAt,
        this.startAt,
        this.endAt,
        this.authAttempts,
        this.totalCount,
        this.paidCount,
        this.customerNotify,
        this.createdAt,
        this.expireBy,
        this.shortUrl,
        this.hasScheduledChanges,
        this.changeScheduledAt,
        this.source,
        this.remainingCount});

  SubscribeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entity = json['entity'];
    planId = json['plan_id'];
    status = json['status'];
    currentStart = json['current_start'];
    currentEnd = json['current_end'];
    endedAt = json['ended_at'];
    quantity = json['quantity'];

    chargeAt = json['charge_at'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    authAttempts = json['auth_attempts'];
    totalCount = json['total_count'];
    paidCount = json['paid_count'];
    customerNotify = json['customer_notify'];
    createdAt = json['created_at'];
    expireBy = json['expire_by'];
    shortUrl = json['short_url'];
    hasScheduledChanges = json['has_scheduled_changes'];
    changeScheduledAt = json['change_scheduled_at'];
    source = json['source'];
    remainingCount = json['remaining_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['entity'] = this.entity;
    data['plan_id'] = this.planId;
    data['status'] = this.status;
    data['current_start'] = this.currentStart;
    data['current_end'] = this.currentEnd;
    data['ended_at'] = this.endedAt;
    data['quantity'] = this.quantity;

    data['charge_at'] = this.chargeAt;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['auth_attempts'] = this.authAttempts;
    data['total_count'] = this.totalCount;
    data['paid_count'] = this.paidCount;
    data['customer_notify'] = this.customerNotify;
    data['created_at'] = this.createdAt;
    data['expire_by'] = this.expireBy;
    data['short_url'] = this.shortUrl;
    data['has_scheduled_changes'] = this.hasScheduledChanges;
    data['change_scheduled_at'] = this.changeScheduledAt;
    data['source'] = this.source;
    data['remaining_count'] = this.remainingCount;
    return data;
  }
}