class HoldingData {
  String? tradingsymbol;
  String? exchange;
  String? isin;
  int? t1quantity;
  int? realisedquantity;
  int? quantity;
  int? authorisedquantity;
  String? product;
  Null? collateralquantity;
  Null? collateraltype;
  int? haircut;
  double? averageprice;
  double? ltp;
  String? symboltoken;
  double? close;
  int? profitandloss;
  double? pnlpercentage;

  HoldingData(
      {this.tradingsymbol,
        this.exchange,
        this.isin,
        this.t1quantity,
        this.realisedquantity,
        this.quantity,
        this.authorisedquantity,
        this.product,
        this.collateralquantity,
        this.collateraltype,
        this.haircut,
        this.averageprice,
        this.ltp,
        this.symboltoken,
        this.close,
        this.profitandloss,
        this.pnlpercentage});

  HoldingData.fromJson(Map<String, dynamic> json) {
    tradingsymbol = json['tradingsymbol'];
    exchange = json['exchange'];
    isin = json['isin'];
    t1quantity = json['t1quantity'];
    realisedquantity = json['realisedquantity'];
    quantity = json['quantity'];
    authorisedquantity = json['authorisedquantity'];
    product = json['product'];
    collateralquantity = json['collateralquantity'];
    collateraltype = json['collateraltype'];
    haircut = json['haircut'];
    averageprice = json['averageprice'];
    ltp = json['ltp'];
    symboltoken = json['symboltoken'];
    close = json['close'];
    profitandloss = json['profitandloss'];
    pnlpercentage = json['pnlpercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tradingsymbol'] = this.tradingsymbol;
    data['exchange'] = this.exchange;
    data['isin'] = this.isin;
    data['t1quantity'] = this.t1quantity;
    data['realisedquantity'] = this.realisedquantity;
    data['quantity'] = this.quantity;
    data['authorisedquantity'] = this.authorisedquantity;
    data['product'] = this.product;
    data['collateralquantity'] = this.collateralquantity;
    data['collateraltype'] = this.collateraltype;
    data['haircut'] = this.haircut;
    data['averageprice'] = this.averageprice;
    data['ltp'] = this.ltp;
    data['symboltoken'] = this.symboltoken;
    data['close'] = this.close;
    data['profitandloss'] = this.profitandloss;
    data['pnlpercentage'] = this.pnlpercentage;
    return data;
  }
}