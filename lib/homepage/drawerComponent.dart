import 'package:flutter/material.dart';

mybtn(btntitle, myfun, icon) {
  return GestureDetector(
    onTap: myfun,
    child: ListTile(
      title: Text(btntitle),
      leading: Icon(icon),
    ),
  );
}
