class Totalholding {
  int? totalholdingvalue;
  int? totalinvvalue;
  double? totalprofitandloss;
  double? totalpnlpercentage;

  Totalholding(
      {this.totalholdingvalue,
        this.totalinvvalue,
        this.totalprofitandloss,
        this.totalpnlpercentage});

  Totalholding.fromJson(Map<String, dynamic> json) {
    totalholdingvalue = json['totalholdingvalue'];
    totalinvvalue = json['totalinvvalue'];
    totalprofitandloss = json['totalprofitandloss'];
    totalpnlpercentage = json['totalpnlpercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalholdingvalue'] = this.totalholdingvalue;
    data['totalinvvalue'] = this.totalinvvalue;
    data['totalprofitandloss'] = this.totalprofitandloss;
    data['totalpnlpercentage'] = this.totalpnlpercentage;
    return data;
  }
}