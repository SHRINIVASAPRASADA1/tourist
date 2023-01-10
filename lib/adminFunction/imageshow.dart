import 'package:flutter/material.dart';

import 'package:touristguide/variable.dart';

class ImageSelected extends StatefulWidget {
  const ImageSelected({super.key});

  @override
  State<ImageSelected> createState() => _ImageSelectedState();
}

class _ImageSelectedState extends State<ImageSelected> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: addHeight(context, 0.40),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: linkOfImage.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Image.network(
              linkOfImage[index],
            ),
          );
        },
      ),
    );
  }
}
