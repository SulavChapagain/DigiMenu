// ignore_for_file: deprecated_member_use

import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

// Function to open email client
void _sendEmail() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'finoedha@gmail.com', // Replace this with your email address
    queryParameters: {
      'subject': 'DigiMenu', // You can customize the subject as needed
      'body':
          'Hello, I have a question regarding...', // You can customize the email body
    },
  );

  if (await canLaunch(emailLaunchUri.toString())) {
    await launch(emailLaunchUri.toString());
  } else {
    throw 'Could not launch email';
  }
}

// Function to open Google link
void _openGoogleLink() async {
  const String url =
      'https://www.google.com'; // Specify the URL you want to redirect to
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

String smallSentence(String bigSentence) {
  if (bigSentence.length > 15) {
    return '${bigSentence.substring(0, 10)}...';
  } else {
    return bigSentence;
  }
}

class _AboutPageState extends State<AboutPage> {
  String userName = "";

  void casheData() async {
    var username = await APICacheManager().getCacheData("UserName");

    setState(() {
      userName = username.syncData;
    });
  }

  @override
  void initState() {
    casheData();
    super.initState();
  }

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  smallSentence(userName),
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
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
            onTap: () {
              _openGoogleLink;
            },
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
