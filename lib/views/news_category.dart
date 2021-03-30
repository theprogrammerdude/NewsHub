import 'package:flutter/material.dart';
import 'package:news_hub/helper/news.dart';
import 'package:news_hub/models/article_model.dart';
import 'package:news_hub/views/article_view.dart';

class NewsCategory extends StatefulWidget {
  final String category;

  NewsCategory({this.category});

  @override
  _NewsCategoryState createState() => _NewsCategoryState();
}

class _NewsCategoryState extends State<NewsCategory> {
  List<ArticleModel> articles = new List<ArticleModel>();

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    getCategoryNews();
  }

  getCategoryNews() async {
    CategoryNews news = CategoryNews();
    await news.getCategoryNews(widget.category);

    articles = news.articles;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('News'),
            Text(
              'Hub',
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        actions: [
          Opacity(
            opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(Icons.ten_k),
            ),
          )
        ],
        elevation: 0,
      ),
      body: _loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: ListView.builder(
                          padding: EdgeInsets.only(top: 15),
                          itemCount: articles.length,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ArticleTile(
                                url: articles[index].url,
                                imageUrl: articles[index].urlToImage,
                                title: articles[index].title,
                                desc: articles[index].description);
                          }),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class ArticleTile extends StatelessWidget {
  final imageUrl, title, desc, url;

  ArticleTile(
      {@required this.imageUrl,
      @required this.title,
      @required this.desc,
      @required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Article(url: url)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              desc,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
