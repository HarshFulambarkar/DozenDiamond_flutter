class StockRecommendedParametersResponse {
  bool? status;
  String? message;
  List<StockRecommendedParametersData>? data;

  StockRecommendedParametersResponse({this.status, this.message, this.data});

  StockRecommendedParametersResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StockRecommendedParametersData>[];
      json['data'].forEach((v) {
        data!.add(new StockRecommendedParametersData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StockRecommendedParametersData {
  int? ddSrpId;
  String? ticker;
  String? targetPriceMultipler;
  // int? stepsSize;
  int? stepsAbove;
  String? ratioMAvgExcStdNormExc;
  String? normExC;
  String? mAvgExcStd;
  String? compoundedExc;
  String? perExcStd;
  String? perExcMedian;
  int? numberOfTrade;
  int? years;
  String? targetMinyear;
  int? stepsMinyear;
  int? minYears;
  String? normExCMinyear;
  int? numberOfTradeMinyear;
  String? initialPrice;

  StockRecommendedParametersData(
      {this.ddSrpId,
        this.ticker,
        this.targetPriceMultipler,
        // this.stepsSize,
        this.stepsAbove,
        this.ratioMAvgExcStdNormExc,
        this.normExC,
        this.mAvgExcStd,
        this.compoundedExc,
        this.perExcStd,
        this.perExcMedian,
        this.numberOfTrade,
        this.years,
        this.targetMinyear,
        this.stepsMinyear,
        this.minYears,
        this.normExCMinyear,
        this.numberOfTradeMinyear,
        this.initialPrice});

  StockRecommendedParametersData.fromJson(Map<String, dynamic> json) {
    ddSrpId = json['dd_srp_id'];
    ticker = json['ticker'];
    targetPriceMultipler = json['target_price_multipler'];
    // stepsSize = json['steps_size'];
    stepsAbove = json['steps_above'];
    ratioMAvgExcStdNormExc = json['ratio_M_avg_exc_std_norm_exc'];
    normExC = json['norm_exC'];
    mAvgExcStd = json['m_avg_exc_std'];
    compoundedExc = json['compounded_exc'];
    perExcStd = json['per_exc_std'];
    perExcMedian = json['per_exc_median'];
    numberOfTrade = json['number_of_trade'];
    years = json['years'];
    targetMinyear = json['target__minyear'];
    stepsMinyear = json['steps_minyear'];
    minYears = json['min_years'];
    normExCMinyear = json['norm_exC_minyear'];
    numberOfTradeMinyear = json['number_of_trade_minyear'];
    initialPrice = json['initial_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dd_srp_id'] = this.ddSrpId;
    data['ticker'] = this.ticker;
    data['target_price_multipler'] = this.targetPriceMultipler;
    // data['steps_size'] = this.stepsSize;
    data['steps_above'] = this.stepsAbove;
    data['ratio_M_avg_exc_std_norm_exc'] = this.ratioMAvgExcStdNormExc;
    data['norm_exC'] = this.normExC;
    data['m_avg_exc_std'] = this.mAvgExcStd;
    data['compounded_exc'] = this.compoundedExc;
    data['per_exc_std'] = this.perExcStd;
    data['per_exc_median'] = this.perExcMedian;
    data['number_of_trade'] = this.numberOfTrade;
    data['years'] = this.years;
    data['target__minyear'] = this.targetMinyear;
    data['steps_minyear'] = this.stepsMinyear;
    data['min_years'] = this.minYears;
    data['norm_exC_minyear'] = this.normExCMinyear;
    data['number_of_trade_minyear'] = this.numberOfTradeMinyear;
    data['initial_price'] = this.initialPrice;
    return data;
  }
}