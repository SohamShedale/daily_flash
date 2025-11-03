import 'package:daily_flash/features/home/models/article_model.dart';

class NewsModel {
  String? status;
  int? totalResults;
  List<Article>? articles;

  NewsModel({this.status, this.totalResults, this.articles});

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    status: json["status"],
    totalResults: json["totalResults"],
    articles: json["articles"] == null ? [] : List<Article>.from(json["articles"]!.map((x) => Article.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "totalResults": totalResults,
    "articles": articles == null ? [] : List<dynamic>.from(articles!.map((x) => x.toJson())),
  };
}
