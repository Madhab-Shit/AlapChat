import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Statuscontroller extends GetxController {
  final firestore = FirebaseFirestore.instance.collection('status');

  Stream<QuerySnapshot<Map<String, dynamic>>> getstatus() {
    return firestore.snapshots();
  }
}
