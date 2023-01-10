import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

User? userIn = FirebaseAuth.instance.currentUser;
List<String> linkOfImage = [];
addHeight(context, myheight) {
  return MediaQuery.of(context).size.height * myheight;
}

heightof(context, size) {
  return MediaQuery.of(context).size.height * size;
}

final ImagePicker _picker = ImagePicker();

final ref = FirebaseStorage.instance;

String imageLink = "";

Future<String?> uploadImageToFirebase(File imageFile, String location) async {
  String? dowloadUrl;
  firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref(location);

  firebase_storage.UploadTask task = ref.putFile(imageFile);
  firebase_storage.TaskSnapshot snapshot = await task;

  await snapshot.ref
      .getDownloadURL()
      .then((value) => dowloadUrl = value.toString());
  return dowloadUrl;
}

String currentSelectedPlace = "";

TextEditingController search = TextEditingController();

String searchstr = "english";

TextEditingController title = TextEditingController();
TextEditingController des = TextEditingController();
TextEditingController his = TextEditingController();
TextEditingController address = TextEditingController();

TextEditingController near = TextEditingController();

String seletedForUpdate = "";
String selectedGuid = "";

TextEditingController name_ = TextEditingController();
TextEditingController lang_ = TextEditingController();
TextEditingController des_on_Guide = TextEditingController();
TextEditingController Place__ = TextEditingController();

TextEditingController addlang = TextEditingController();

String guideName = "";

String searchList = " ";

List<String> admin = [
  "prasadashrinivasa@gmail.com",
  "aanushaalexander@gmail.com",
];

TextEditingController username = TextEditingController();

TextEditingController phonenumber = TextEditingController();

TextEditingController addres = TextEditingController();
TextEditingController ratting = TextEditingController();
TextEditingController adhar = TextEditingController();
TextEditingController phoneNum = TextEditingController();

double totalRattingOfGuide = 0;
int numberOfIteration = 0;

int price_ = 0;

String selected_mobile_number = "";
