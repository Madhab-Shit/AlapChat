import 'dart:io';

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
}
