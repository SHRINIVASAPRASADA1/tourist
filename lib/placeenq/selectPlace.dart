import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:touristguide/homepage/place.dart';
import 'package:touristguide/placeenq/BookPlace.dart';

class SelectPlace extends StatefulWidget {
  const SelectPlace({super.key});

  @override
  State<SelectPlace> createState() => _SelectPlaceState();
}

class _SelectPlaceState extends State<SelectPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const BookPlace(),
    );
  }
}
