class ArticleModel {
  final String id;
  final String title;
  final String content;
  final String? articleImage;
  final String author;
  final String createdAt;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    this.articleImage,
    required this.author,
    required this.createdAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      articleImage: json['articleImage'],
      author: json['author'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'title': this.title,
      'content': this.content,
      'articleImage': this.articleImage,
      'author': this.author,
      'createdAt': this.createdAt,
    };
  }
}
