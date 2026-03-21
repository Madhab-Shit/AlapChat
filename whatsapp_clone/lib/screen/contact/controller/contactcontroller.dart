import 'dart:developer';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Contactcontroller extends GetxController {
  RxBool isloading = false.obs;
  RxList contectcheck = [].obs;
  late final data;

  RxBool search = false.obs;

  RxList<Contact> contacts = <Contact>[].obs;

  Future<void> getContact1() async {
    try {
      isloading.value = true;

      if (await Permission.contacts.request().isGranted) {
        data = await FlutterContacts.getContacts(withProperties: true);

        contacts.assignAll(data);
      } else {
        log("Permission Denied");
      }
    } catch (e) {
      print(e);
    } finally {
      isloading.value = false;
      contectcheck.value = List.generate(contacts.length, (index) => false);
    }
  }

  void searchdata(String value) {
    if (value.isEmpty) {
      contacts.assignAll(data);
    } else {
      var result = data
          .where(
            (item) =>
                item.displayName.toString().toLowerCase().contains(
                  value.toLowerCase(),
                ) ||
                item.phones.first.number.toString().toLowerCase().contains(
                  value.toLowerCase(),
                ),
          )
          .toList();
      contacts.assignAll(result);
    }
  }
}
