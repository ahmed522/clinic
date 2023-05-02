import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeLineController extends GetxController {
  static TimeLineController get find => Get.find();
  final _db = FirebaseFirestore.instance;
  final RxList<Widget> content = <Widget>[].obs;
  loadPosts() {
    CollectionReference usersCollection = _db.collection('users');
    usersCollection.get().then((QuerySnapshot snapshot) {});
  }
}
