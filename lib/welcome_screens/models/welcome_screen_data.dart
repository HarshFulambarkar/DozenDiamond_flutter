class WelcomeScreenData {
  int? id;
  String? title;
  String? imageUrl;

  WelcomeScreenData({this.id, this.title, this.imageUrl});

  @override
  WelcomeScreenData fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['image_url'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;

    return data;
  }
}