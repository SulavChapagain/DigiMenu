import 'dart:convert';

import 'package:digimenu/screen/items.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String smallSentence(String bigSentence) {
  if (bigSentence.length > 15) {
    return '${bigSentence.substring(0, 15)}...';
  } else {
    return bigSentence;
  }
}

class _HomePageState extends State<HomePage> {
  List foodHeading = [];
  List searchResults = [];

  Future<void> viewMenudata() async {
    String uri =
        "https://digitalmenu.finoedha.com/ViewProductHeading.php?id=1706112669";
    try {
      var response = await http.get(Uri.parse(uri));

      setState(() {
        foodHeading = jsonDecode(response.body);
        searchResults = foodHeading;
      });
    } catch (e) {
      print(e);
    }
  }

  void onQueryChanged(String query) {
    setState(() {
      searchResults = foodHeading
          .where((item) =>
              item["heading"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    viewMenudata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Color.fromARGB(255, 4, 65, 100),
        tooltip: 'Increment',
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text(
          "DigiMenu",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        actions: <Widget>[
          Text(
            smallSentence("The Tiffin Box Kawasoti prali"),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          viewMenudata();
        },
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                onChanged: onQueryChanged,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search Items",
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:
                            Text(searchResults[index]["heading"].toUpperCase()),
                        trailing: Icon(Icons.arrow_right_outlined),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const ItemPage()));
                        },
                      );
                    })),
          ],
        ),
      ),
    ));
  }
}
