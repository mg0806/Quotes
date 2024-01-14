import 'package:chatapp/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class QuotesPage extends StatefulWidget {
  late final String categoryname;
  QuotesPage(this.categoryname);

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}
//Creating a web scrapper to extract quotes fro the given url website and show them in the app.
class _QuotesPageState extends State<QuotesPage> {
  List quotes = [];
  List authors = [];
  bool isDataThere = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getquotes();
  }
  // creating the function async as it requires time to fetch url data.
  getquotes() async {
    String url = "https://quotes.toscrape.com/tag/${widget.categoryname}/";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesclass = document.getElementsByClassName("quote");
// fetching the class named as quoteclass on the website and adding them to quotes list created above.
    quotes = quotesclass
        .map((element) => element.getElementsByClassName('text')[0].innerHtml)
        .toList();
        // similar to above process just here we are adding authors to the authors list.
    authors = quotesclass
        .map((element) => element.getElementsByClassName('author')[0].innerHtml)
        .toList();
// created a isdatathere boolean variable to check whether is the data or not and provide a circular
//progess indicator showing that we are gathreing the data.
    setState(() {
      isDataThere = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //showing the quotes available in 4 different categories.
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: isDataThere == false
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.only(top: 50),
                    child: Text(
                      "${widget.categoryname} quotes".toUpperCase(),
                      style: textStyle(28,
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ),
                  //creating a listview to show quotes in a list form.
                
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: quotes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 10,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, bottom: 20),
                                child: Text(quotes[index],
                                    style: textStyle(18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(authors[index],
                                    style: textStyle(15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700)),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
    );
  }
}
