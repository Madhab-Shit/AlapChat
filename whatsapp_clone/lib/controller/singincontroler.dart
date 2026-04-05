import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traychat/navigationpage.dart';
import 'package:traychat/signup.dart';

class Getx extends GetxController {
  RxBool singin = true.obs;
  RxString username = "".obs;
  RxString phone = ''.obs;

  RxBool privay = false.obs;
  RxBool showEmoji = false.obs;

  final ImagePicker picker = ImagePicker();

  final ImagePicker opencamera = ImagePicker();
  File? image;

  RxBool isloading = false.obs;
  Future<void> uploadstory(String pathstatus) async {
    try {
      isloading = true.obs;
      await FirebaseFirestore.instance
          .collection('status')
          .doc(username.value)
          .set({
            'username': username.value,
            'item': FieldValue.arrayUnion([
              {
                'video': pathstatus,
                'createdAt': Timestamp.now(),
                'expiresAt': Timestamp.fromDate(
                  DateTime.now().add(Duration(hours: 24)),
                ),
              },
            ]),
          }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    } finally {
      isloading = false.obs;
    }
  }

  final _firestore = FirebaseFirestore.instance;
  Future<void> loginUser(String uid, String password) async {
    try {
      isloading.value = true;
      final docRef = _firestore.collection('users').doc(uid);
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        Get.snackbar('Error', 'User not found');
        return;
      }

      final data = snapshot.data()!;
      if (data['password'] != password) {
        Get.snackbar('Error', 'Wrong password');
        return;
      }

      Get.snackbar('Success', 'Login Successful');

      loginUsername(data['uid']);
      loginPhone(uid);
      // getx.phone.value = uid;
      // log(getx.phone.value);
      // getx.username.value = data['uid'];
      Get.offAll(Navigationpage());
    } catch (e) {
      throw Exception(e);
    } finally {
      isloading.value = false;
    }
  }
}
