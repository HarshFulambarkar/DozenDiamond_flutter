class GenerateOrderData {
  int? amount;
  int? amountDue;
  int? amountPaid;
  int? attempts;
  int? createdAt;
  String? currency;
  String? entity;
  String? id;
  List<Null>? notes;
  Null? offerId;
  String? receipt;
  String? status;

  GenerateOrderData(
      {this.amount,
        this.amountDue,
        this.amountPaid,
        this.attempts,
        this.createdAt,
        this.currency,
        this.entity,
        this.id,
        this.notes,
        this.offerId,
        this.receipt,
        this.status});

  GenerateOrderData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    amountDue = json['amount_due'];
    amountPaid = json['amount_paid'];
    attempts = json['attempts'];
    createdAt = json['created_at'];
    currency = json['currency'];
    entity = json['entity'];
    id = json['id'];
    // if (json['notes'] != null) {
    //   notes = <Null>[];
    //   json['notes'].forEach((v) {
    //     notes!.add(new Null.fromJson(v));
    //   });
    // }
    offerId = json['offer_id'];
    receipt = json['receipt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['amount_due'] = this.amountDue;
    data['amount_paid'] = this.amountPaid;
    data['attempts'] = this.attempts;
    data['created_at'] = this.createdAt;
    data['currency'] = this.currency;
    data['entity'] = this.entity;
    data['id'] = this.id;
    // if (this.notes != null) {
    //   data['notes'] = this.notes!.map((v) => v.toJson()).toList();
    // }
    data['offer_id'] = this.offerId;
    data['receipt'] = this.receipt;
    data['status'] = this.status;
    return data;
  }
}