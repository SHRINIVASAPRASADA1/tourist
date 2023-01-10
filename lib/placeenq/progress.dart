import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:touristguide/homepage/HomePage.dart';

class ProgressDone extends StatelessWidget {
  const ProgressDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Lottie.asset("assets/icon/anime.json"),
        ),
      ),
    );
  }
}
