import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traychat/screen/contact/controller/contactcontroller.dart';

class Catactnumber extends StatefulWidget {
  const Catactnumber({super.key});

  @override
  State<Catactnumber> createState() => _CatactnumberState();
}

class _CatactnumberState extends State<Catactnumber> {
  final getcontrollet = Get.put(Contactcontroller());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcontrollet.getContact1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Contact Number"),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Obx(
        () => getcontrollet.isloading.value
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: getcontrollet.contacts.length,
                itemBuilder: (context, index) {
                  final contact = getcontrollet.contacts[index];

                  return GestureDetector(
                    onTap: () {
                      print(index.toString());
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          contact.displayName.toString().split("").first,
                        ),
                      ),
                      title: Text(contact.displayName.toString()),

                      subtitle: contact.phones.isNotEmpty
                          ? Text(contact.phones.first.number)
                          : Text("No Number"),
                    ),
                  );
                  ;
                },
              ),
      ),
    );
  }
}
