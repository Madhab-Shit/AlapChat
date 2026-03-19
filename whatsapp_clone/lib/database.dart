import 'package:cloud_firestore/cloud_firestore.dart';

class database{
  final moviesRef = FirebaseFirestore.instance.collection('chat');
  Future<void> sendSms({String text = "", int uid = 0}) async {
    try {

      moviesRef.add({'text': text, 'time': Timestamp.now(), 'uid': uid});
    } catch (e) {
      throw Exception(e);
    }
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> readSms() {
    try {
      return moviesRef.orderBy('time', descending: false).snapshots();
    } catch (e) {
      throw Exception(e);
    }
  }
}