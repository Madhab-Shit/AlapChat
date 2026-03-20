import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traychat/screen/contact/controller/contactcontroller.dart';
import 'package:traychat/screen/sendcontact/ui/sendcontect.dart';

class Catactnumber extends StatefulWidget {
  final String myid;
  final String otherid;
  const Catactnumber({super.key,required this.myid,required this.otherid});

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
    List contectcollect = [];
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
                      getcontrollet.contectcheck[index] =
                          !getcontrollet.contectcheck[index];

                      final data = {
                        'name': contact.displayName,
                        'phone': contact.phones.isNotEmpty
                            ? contact.phones.first.number
                            : "",
                      };

                      final exists = contectcollect.any(
                        (e) =>
                            e['name'] == data['name'] &&
                            e['phone'] == data['phone'],
                      );

                      if (exists) {
                        contectcollect.removeWhere(
                          (e) =>
                              e['name'] == data['name'] &&
                              e['phone'] == data['phone'],
                        );
                      } else {
                        contectcollect.add(data);
                      }
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
                      trailing: Obx(
                        () => Checkbox(
                          value: getcontrollet.contectcheck[index],
                          onChanged: (value) {
                            getcontrollet.contectcheck[index] = value;
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff34B271),
        onPressed: () {
          if (contectcollect.isEmpty) {
            return;
          }
          Get.to(() => Sendcontect(contectcount: contectcollect,myid: widget.myid,otherid: widget.otherid,));
        },
        child: Icon(
          Icons.arrow_forward_outlined,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}
