import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class userData extends StatefulWidget {
  const userData({super.key});

  @override
  State<userData> createState() => _userDataState();
}

class _userDataState extends State<userData> {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  bool isload = false;

  Future<void> userdataid() async {
    setState(() {
      isload = true;
    });
    var userID = await APICacheManager().getCacheData("UserID");

    try {
      String uri = "https://digitalmenu.finoedha.com/userprofile.php";

      var res = await http.post(Uri.parse(uri), body: {
        "businessName": name.text,
        "number": number.text,
        "userId": userID.syncData,
      });

      var response = jsonDecode(res.body);
      if (response['success'] == 'true') {
        await APICacheManager().addCacheData(
            APICacheDBModel(key: "UserName", syncData: name.text));
        await APICacheManager().addCacheData(
            APICacheDBModel(key: "UserNumber", syncData: number.text));

        setState(() {
          isload = false;
        });
        Navigator.of(context).pop("refresh");
      }
    } catch (e) {
      setState(() {
        isload = false;
      });
    }
  }

  Future<void> localdata() async {
    var username = await APICacheManager().getCacheData("UserName");
    var userNumber = await APICacheManager().getCacheData("UserNumber");
    if (username.syncData.isNotEmpty) {
      setState(() {
        name.text = username.syncData;
        number.text = userNumber.syncData;
      });
    }
  }

  @override
  void initState() {
    localdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Textfieldbox(
            controller: name,
            title: const Text("Business Name"),
            keyboardType: TextInputType.name,
          ),
          Textfieldbox(
            controller: number,
            title: const Text("Number"),
            keyboardType: TextInputType.phone,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: () {
                userdataid();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue),
                child: Center(
                    child: isload
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Done",
                            style: TextStyle(color: Colors.white),
                          )),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Textfieldbox extends StatelessWidget {
  final Text title;
  final TextInputType keyboardType;
  final TextEditingController controller;
  const Textfieldbox({
    super.key,
    required this.title,
    required this.keyboardType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          label: title,
        ),
      ),
    );
  }
}
