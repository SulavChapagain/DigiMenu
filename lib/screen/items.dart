import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

String smallSentence(String bigSentence) {
  if (bigSentence.length > 15) {
    return '${bigSentence.substring(0, 15)}...';
  } else {
    return bigSentence;
  }
}

class _ItemPageState extends State<ItemPage> {
  List foodHeading = [];
  List searchResults = [];

  Future<void> viewMenudata() async {
    String uri =
        "https://digitalmenu.finoedha.com/menuitem.php?userid=1706112669&tableId=540170";
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
              item["title"].toLowerCase().contains(query.toLowerCase()))
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
                        title: Text(searchResults[index]["title"]),
                        trailing: Text("Rs. ${searchResults[index]["price"]}"),
                        subtitle: searchResults[index]["detail"] != ""
                            ? Text(
                                smallSentence(searchResults[index]["detail"]))
                            : null,
                        onTap: () {},
                      );
                    })),
          ],
        ),
      ),
    ));
  }
}
