import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:touristguide/adminFunction/adminpanel.dart';
import 'package:touristguide/adminFunction/insertGuide.dart';
import 'package:touristguide/adminFunction/insertPlace.dart';
import 'package:touristguide/adminFunction/updateSlider.dart';
import 'package:touristguide/authontication/signup.dart';
import 'package:touristguide/homepage/drawer/mybook.dart';
import 'package:touristguide/homepage/drawerComponent.dart';
import 'package:touristguide/homepage/guide.dart';
import 'package:touristguide/homepage/place.dart';
import 'package:touristguide/homepage/search.dart';
import 'package:touristguide/placeenq/viewPlace.dart';
import 'package:touristguide/variable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Tourist guide"),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SEARCHBOX(),
                ),
              );
            },
            child: const Icon(
              Icons.search,
              size: 31,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future:
                  FirebaseFirestore.instance.collection("carouselSlider").get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData ||
                    snapshot.hasError) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                        top: MediaQuery.of(context).size.width * 0.05,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      width: double.infinity,
                      height: heightof(context, 0.25),
                    ),
                  );
                }

                return CarouselSlider(
                  items: [
                    for (var item in snapshot.data!.docs)
                      GestureDetector(
                        onTap: () {
                          currentSelectedPlace = item['id'];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewPlace(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05,
                            top: MediaQuery.of(context).size.width * 0.05,
                          ),
                          decoration: BoxDecoration(
                              // color: const Color.fromARGB(92, 247, 244, 244),
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                color: Colors.transparent,
                                height: heightof(context, 0.19),
                                child: CachedNetworkImage(
                                  imageUrl: item['img'].toString(),
                                  // progressIndicatorBuilder:
                                  //     (context, url, downloadProgress) =>
                                  //         const Center(
                                  //   child: CircularProgressIndicator(),
                                  // ),
                                ),
                              ),
                              Text(
                                item['title'],
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.raleway(
                                  textStyle: const TextStyle(
                                    fontFamily: "Open Sans",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                  options: CarouselOptions(
                      viewportFraction: 1,
                      autoPlay: true,
                      reverse: true,
                      onPageChanged: (index, reaon) {}),
                );
              },
            ),
            const Text(
              "Guides",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.13,
              child: const GuideList(),
            ),
            const Text(
              "Places",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const ShowPlace()
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.5,
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                color: Colors.tealAccent,
              ),

              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(23),
                  ),
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.10,
                    backgroundImage: NetworkImage(
                      userIn!.photoURL.toString(),
                    ),
                  ),
                  Text(userIn!.email.toString()),
                  const Padding(padding: EdgeInsets.all(5)),
                  Text(userIn!.metadata.creationTime.toString()),
                  Text(userIn!.metadata.lastSignInTime.toString()),
                ],
              ),
            ),
            mybtn("My Bookings", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Mybookings(),
                ),
              );
            }, Icons.track_changes),
            mybtn("LOGOUT", () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              // ignore: use_build_context_synchronously

              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupWithGoogle(),
                  ),
                  (route) => false);
            }, Icons.logout),
            userIn!.email == "aanushaalexander@gmail.com"
                ? mybtn(
                    "ADMIN PANEL",
                    () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const AdminPanel(),
                        ),
                      );
                    },
                    Icons.admin_panel_settings,
                  )
                : const Text(""),
            userIn!.email == "prasadashrinivasa@gmail.com"
                ? mybtn(
                    "ADMIN PANEL",
                    () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const AdminPanel(),
                        ),
                      );
                    },
                    Icons.admin_panel_settings,
                  )
                : const Text(""),
          ],
        ),
      ),
    );
  }
}
