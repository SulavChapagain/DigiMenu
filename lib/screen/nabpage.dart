import 'package:digimenu/screen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeNabvar extends StatefulWidget {
  const HomeNabvar({super.key});

  @override
  State<HomeNabvar> createState() => _HomeNabvarState();
}

class _HomeNabvarState extends State<HomeNabvar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.text_justify), label: "Templates"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled), label: "About"),
        ]),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (context) {
                  return const CupertinoPageScaffold(child: HomePage());
                },
              );
          }
          return Container();
        });
  }
}
