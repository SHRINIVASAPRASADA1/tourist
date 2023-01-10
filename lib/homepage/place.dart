import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:touristguide/placeenq/viewPlace.dart';
import 'package:touristguide/variable.dart';

class ShowPlace extends StatefulWidget {
  const ShowPlace({super.key});

  @override
  State<ShowPlace> createState() => _ShowPlaceState();
}

class _ShowPlaceState extends State<ShowPlace> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("Places").get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        }
        return Wrap(
          children: [
            for (var item in snapshot.data!.docs)
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentSelectedPlace = item.id;
                    price_ = item['price'];
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPlace(),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.46,
                  height: MediaQuery.of(context).size.height * 0.19,
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(37, 0, 0, 0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        width: MediaQuery.of(context).size.width * 0.42,
                        height: MediaQuery.of(context).size.height * 0.13,
                        child: Image.network(
                          item['img'][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item['address'],
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
