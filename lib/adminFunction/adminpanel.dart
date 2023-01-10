import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:touristguide/adminFunction/UpdatePlace.dart';
import 'package:touristguide/adminFunction/addLang.dart';
import 'package:touristguide/adminFunction/editGuide.dart';
import 'package:touristguide/adminFunction/insertGuide.dart';
import 'package:touristguide/adminFunction/insertPlace.dart';
import 'package:touristguide/adminFunction/totalOrder.dart';
import 'package:touristguide/adminFunction/updateSlider.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Wrap(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InsertPlace(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                  color: Colors.black,
                ),
              ),
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(7),
              child: Column(
                children: const [
                  Icon(
                    Icons.add_home_work,
                    size: 100,
                  ),
                  Text("ADD PLACE")
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InsertGuide(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                  color: Colors.black,
                ),
              ),
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(7),
              child: Column(
                children: const [
                  Icon(
                    Icons.person_add_alt,
                    size: 100,
                  ),
                  Text("ADD GUIDE")
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateSlider(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                  color: Colors.black,
                ),
              ),
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(7),
              child: Column(
                children: const [
                  Icon(
                    Icons.update,
                    size: 100,
                  ),
                  Text("UPDATE SLIDER")
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EDITGUIDE(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                  color: Colors.black,
                ),
              ),
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(7),
              child: Column(
                children: const [
                  Icon(
                    Icons.edit_note,
                    size: 100,
                  ),
                  Text("EDIT GUIDE")
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdatePlace(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                  color: Colors.black,
                ),
              ),
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(7),
              child: Column(
                children: const [
                  Icon(
                    Icons.add_location_alt,
                    size: 100,
                  ),
                  Text("EDIT PLACE")
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddLanguage(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                  color: Colors.black,
                ),
              ),
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(7),
              child: Column(
                children: const [
                  Icon(
                    Icons.language,
                    size: 100,
                  ),
                  Text("ADD LANG")
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Bookings(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                  color: Colors.black,
                ),
              ),
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(7),
              child: Column(
                children: const [
                  Icon(
                    Icons.list_alt_rounded,
                    size: 100,
                  ),
                  Text("BOOKINGS")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
