import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_hub/helper/news.dart';
import 'package:news_hub/models/article_model.dart';
import 'package:news_hub/models/category_model.dart';
import 'package:news_hub/helper/data.dart';
import 'package:news_hub/views/article_view.dart';
import 'package:news_hub/views/news_category.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();

    getNews();
  }

  getNews() async {
    News news = News();
    await news.getNews();

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
                child: Column(children: <Widget>[
                  // Categories
                  Container(
                    height: 80,
                    child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoryCard(
                            imageUrl: categories[index].imageUrl,
                            categoryName: categories[index].categoryName,
                          );
                        }),
                  ),
                  // Articles
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
                ]),
              ),
            ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageUrl, categoryName;

  CategoryCard({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewsCategory(
                        category: categoryName.toLowerCase(),
                      )));
        },
        child: Container(
          margin: EdgeInsets.only(right: 5),
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 120,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 120,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  categoryName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ));
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
