import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class itemUpdate extends StatefulWidget {
  final itemName;
  final itemPrice;
  final itemDetail;
  final itemTableId;

  const itemUpdate({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.itemDetail,
    required this.itemTableId,
  });

  @override
  State<itemUpdate> createState() => _itemUpdateState();
}

class _itemUpdateState extends State<itemUpdate> {
  TextEditingController itemTexttitle = TextEditingController();
  TextEditingController itemTextprice = TextEditingController();
  TextEditingController itemTextdetail = TextEditingController();

  Future<void> deleteItem() async {
    try {
      String uri = "https://digitalmenu.finoedha.com/delete.php";

      var res = await http.post(Uri.parse(uri), body: {
        "menuheadingId": widget.itemTableId,
      });

      var response = jsonDecode(res.body);
      if (response['sucess'] == 'true') {
        Navigator.of(context).pop("refresh");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateItem() async {
    try {
      String uri = "https://digitalmenu.finoedha.com/update.php";

      var res = await http.post(Uri.parse(uri), body: {
        "headingID": widget.itemTableId,
        "heading": itemTexttitle.text,
        "price": itemTextprice.text,
        "detail": itemTextdetail.text,
      });

      var response = jsonDecode(res.body);
      if (response['sucess'] == 'true') {
        Navigator.of(context).pop("refresh");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    itemTexttitle.text = widget.itemName;
    itemTextprice.text = widget.itemPrice;
    itemTextdetail.text = widget.itemDetail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          inputform(
            labeldata: "Name",
            keyboardType: TextInputType.name,
            initialValue: widget.itemName,
            controller: itemTexttitle,
          ),
          inputform(
            labeldata: "Price",
            keyboardType: TextInputType.number,
            initialValue: widget.itemPrice,
            controller: itemTextprice,
          ),
          inputform(
            labeldata: "Detail",
            keyboardType: TextInputType.name,
            initialValue: widget.itemDetail,
            controller: itemTextdetail,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      deleteItem();
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                    onPressed: () {
                      updateItem();
                    },
                    child: const Text("Update")),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class inputform extends StatelessWidget {
  final String labeldata;
  final TextInputType keyboardType;
  final initialValue;
  final controller;
  const inputform({
    super.key,
    required this.labeldata,
    required this.keyboardType,
    required this.initialValue,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(label: Text(labeldata)),
      ),
    );
  }
}
