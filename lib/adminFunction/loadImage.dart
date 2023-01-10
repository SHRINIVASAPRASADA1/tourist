import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:touristguide/variable.dart';

class LoadImage extends StatefulWidget {
  const LoadImage({super.key});

  @override
  State<LoadImage> createState() => _LoadImageState();
}

class _LoadImageState extends State<LoadImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.width * 0.30,
      child: Image.network(imageLink != ""
          ? imageLink
          : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4_cwAMo1aXZLsgCophAJsCB0Xh4suFCk7v5CtYZvHy3mpEa7acXgC4ZoW7uTMazmGya0&usqp=CAU"),
    );
  }
}
