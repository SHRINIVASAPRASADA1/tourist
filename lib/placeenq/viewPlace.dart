import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristguide/authontication/collectUserData.dart';
import 'package:touristguide/placeenq/searchGuide.dart';
import 'package:touristguide/variable.dart';

class ViewPlace extends StatefulWidget {
  const ViewPlace({super.key});

  @override
  State<ViewPlace> createState() => _ViewPlaceState();
}

class _ViewPlaceState extends State<ViewPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoButton(
        color: Colors.blue,
        child: const Text("Book a Guide"),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const CollectUserData(),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text(currentSelectedPlace),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("Places")
                .doc(currentSelectedPlace)
                .get(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData ||
                  snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    items: [
                      for (var item in snapshot.data!['img'])
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05,
                              top: MediaQuery.of(context).size.width * 0.05,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: Colors.transparent,
                              height: heightof(context, 0.19),
                              child: CachedNetworkImage(
                                imageUrl: item.toString(),
                              ),
                            ),
                          ),
                        ),
                    ],
                    options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: true,
                        reverse: true,
                        onPageChanged: (index, reaon) {}),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      snapshot.data!['title'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      " Service charge ₹ ${snapshot.data!['price'].toString()}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 0, 68, 2),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: const Text(
                      "Located",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(snapshot.data!['located']),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: const Text(
                      "Route",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      snapshot.data!['address'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: const Text(
                      "Nearest Places",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  for (var item in snapshot.data!['near'])
                    Container(
                      padding: const EdgeInsets.only(left: 7, top: 4),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text("${snapshot.data!['des']}"),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: const Text(
                      "History",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(snapshot.data!['history']),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
