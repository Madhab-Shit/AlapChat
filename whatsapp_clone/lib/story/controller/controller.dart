import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

class sorycontroler extends GetxController {
  void viewcount(String name) async {
    final ref = FirebaseFirestore.instance
        .collection('status')
        .doc(name);
    final snapshort = await ref.get();
    List items = snapshort['item'];
    items[0]['view'] = (items[0]['view'] ?? 0) + 1;
    await ref.update({'item': items});
  }
}
