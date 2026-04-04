import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';

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
              {'video': pathstatus},
            ]),
          }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    } finally {
      isloading = false.obs;
    }
  }
}
