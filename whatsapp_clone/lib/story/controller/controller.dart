import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

class sorycontroler extends GetxController {
  void viewcount(String name, String currentUser, int index) async {
    var ref = FirebaseFirestore.instance.collection('status').doc(name);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      var doc = await transaction.get(ref);
      if (!doc.exists) return;
      List items = doc['item'];
      if (items.length <= index) return;
      List users = items[index]['user'] ?? [];
      bool alreadySeen = users.any((u) => u['name'] == currentUser);
      if (!alreadySeen) {
        users.add({'name': currentUser, 'seenAt': Timestamp.now()});
        items[index]['user'] = users;
        items[index]['view'] = (items[index]['view'] ?? 0) + 1;
      }
      transaction.update(ref, {'item': items});
    });
  }
}
