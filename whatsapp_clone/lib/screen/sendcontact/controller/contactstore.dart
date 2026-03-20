import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

class Contactstore extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String getChatId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return user1 + "_" + user2;
    } else {
      return user2 + "_" + user1;
    }
  }

  void chatdata(String send, String recivers, List sms) async {
    for (int i = 0; i < sms.length; i++) {
      log(sms[i]['name']);

      String chatId = getChatId(send, recivers);
      await _firestore.collection('chatdata').doc(chatId).set({
        'lastMessage': sms[i]['name'],
        'sender': send,
        'receiver': chatId,
        'time': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _firestore
          .collection('chatdata')
          .doc(chatId)
          .collection(chatId)
          .add({
            'type': 'contact',
            'message': sms[i]['name'],
            'Phone': sms[i]['phone'],
            'time': FieldValue.serverTimestamp(),
            'sender': send,
            'receiver': recivers,
          });
    }
  }
}
