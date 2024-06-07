import 'package:digimenu/screen/nabpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:digimenu/screen/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var rought;

  void userCheck() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("UserID");
    if (isCacheExist) {
      setState(() {
        rought = const HomeNabvar();
      });
    } else {
      setState(() {
        rought = const LoginPage();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userCheck();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => rought));
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Image.asset(
              "assets/pictures/OfficialLogo.png",
              width: 45,
            ),
          ),
        ),
      ),
    );
  }
}
