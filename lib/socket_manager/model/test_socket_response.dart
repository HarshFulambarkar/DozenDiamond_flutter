class TestSocketResponse {
  List<TestWebSocketData>? data;
  String? type;

  TestSocketResponse({this.data, this.type});

  TestSocketResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TestWebSocketData>[];
      json['data'].forEach((v) {
        data!.add(new TestWebSocketData.fromJson(v));
      });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    return data;
  }
}

class TestWebSocketData {
  double? p;
  String? s;
  int? t;
  double? v;

  TestWebSocketData({this.p, this.s, this.t, this.v});

  TestWebSocketData.fromJson(Map<String, dynamic> json) {
    p = json['p'];
    s = json['s'];
    t = json['t'];
    v = json['v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['p'] = this.p;
    data['s'] = this.s;
    data['t'] = this.t;
    data['v'] = this.v;
    return data;
  }
}