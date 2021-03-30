import 'dart:convert';

import 'package:news_hub/helper/api.dart';
import 'package:news_hub/models/article_model.dart';
import 'package:http/http.dart' as http;

class News {
  List<ArticleModel> articles = [];

  Future<void> getNews() async {
    var url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=$api");

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element["description"] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element["title"],
            description: element["description"],
            urlToImage: element["urlToImage"],
            url: element["url"],
            content: element["content"],
            //publishedAt: element["publishedAt"]
          );

          articles.add(articleModel);
        }
      });
    }
  }
}

class CategoryNews {
  List<ArticleModel> articles = [];

  Future<void> getCategoryNews(String category) async {
    var url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?category=$category&country=in&apiKey=$api");

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element["description"] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element["title"],
            description: element["description"],
            urlToImage: element["urlToImage"],
            url: element["url"],
            content: element["content"],
            //publishedAt: element["publishedAt"]
          );

          articles.add(articleModel);
        }
      });
    }
  }
}
