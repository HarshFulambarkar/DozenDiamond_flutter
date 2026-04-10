class FundsAndMarginsData {
  String? net;
  String? availablecash;
  String? availableintradaypayin;
  String? availablelimitmargin;
  String? collateral;
  String? m2munrealized;
  String? m2mrealized;
  String? utiliseddebits;
  Null? utilisedspan;
  Null? utilisedoptionpremium;
  Null? utilisedholdingsales;
  Null? utilisedexposure;
  Null? utilisedturnover;
  String? utilisedpayout;

  FundsAndMarginsData(
      {this.net,
        this.availablecash,
        this.availableintradaypayin,
        this.availablelimitmargin,
        this.collateral,
        this.m2munrealized,
        this.m2mrealized,
        this.utiliseddebits,
        this.utilisedspan,
        this.utilisedoptionpremium,
        this.utilisedholdingsales,
        this.utilisedexposure,
        this.utilisedturnover,
        this.utilisedpayout});

  FundsAndMarginsData.fromJson(Map<String, dynamic> json) {
    net = json['net'];
    availablecash = json['availablecash'];
    availableintradaypayin = json['availableintradaypayin'];
    availablelimitmargin = json['availablelimitmargin'];
    collateral = json['collateral'];
    m2munrealized = json['m2munrealized'];
    m2mrealized = json['m2mrealized'];
    utiliseddebits = json['utiliseddebits'];
    utilisedspan = json['utilisedspan'];
    utilisedoptionpremium = json['utilisedoptionpremium'];
    utilisedholdingsales = json['utilisedholdingsales'];
    utilisedexposure = json['utilisedexposure'];
    utilisedturnover = json['utilisedturnover'];
    utilisedpayout = json['utilisedpayout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['net'] = this.net;
    data['availablecash'] = this.availablecash;
    data['availableintradaypayin'] = this.availableintradaypayin;
    data['availablelimitmargin'] = this.availablelimitmargin;
    data['collateral'] = this.collateral;
    data['m2munrealized'] = this.m2munrealized;
    data['m2mrealized'] = this.m2mrealized;
    data['utiliseddebits'] = this.utiliseddebits;
    data['utilisedspan'] = this.utilisedspan;
    data['utilisedoptionpremium'] = this.utilisedoptionpremium;
    data['utilisedholdingsales'] = this.utilisedholdingsales;
    data['utilisedexposure'] = this.utilisedexposure;
    data['utilisedturnover'] = this.utilisedturnover;
    data['utilisedpayout'] = this.utilisedpayout;
    return data;
  }
}