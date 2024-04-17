import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text(
          "DigiMenu",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        actions: const <Widget>[
          Text(
            "About",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Tiffin Box",
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  CupertinoIcons.pencil,
                  size: 30,
                )
              ],
            ),
          ),
          const Text("Status: Free"),
          const Text("Time Left: 5m"),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: const Text("View Menu"),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Your QR code"),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Analytics"),
            trailing: const Icon(Icons.lock),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Purchase"),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Contact us"),
            onTap: () {},
          ),
          ListTile(
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {},
          ),
        ],
      ),
    ));
  }
}
