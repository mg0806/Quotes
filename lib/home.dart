import "package:chatapp/quotespage.dart";
import "package:chatapp/utils.dart";
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: non_constant_identifier_names
  List<String> Categories = ["love", "inspirational", "life", "humor"];
  List quotes = [];
  List authors = [];
  bool isDataThere = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getquotes();
  }

  getquotes() async {
    String url = "https://quotes.toscrape.com/";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesclass = document.getElementsByClassName("quote");

    quotes = quotesclass
        .map((element) => element.getElementsByClassName('text')[0].innerHtml)
        .toList();
    authors = quotesclass
        .map((element) => element.getElementsByClassName('author')[0].innerHtml)
        .toList();

    setState(() {
      isDataThere = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //main home page.
        body: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            // ignore: prefer_const_constructors
            margin: EdgeInsets.only(top: 50),
            child: Text(
              "Quotes App",
              style: textStyle(30,
                  color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: Categories.map((category) {
              return InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuotesPage(category))),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      category.toUpperCase(),
                      style: textStyle(17,
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(
            height: 40,
          ),
          isDataThere == false
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
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
    ));
  }
}
