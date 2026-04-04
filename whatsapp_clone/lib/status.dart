import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traychat/controller/singincontroler.dart';
import 'package:traychat/mystatus/screen/mystatus.dart';
import 'package:traychat/story/story.dart';
import 'package:traychat/test.dart';

import 'controller/statuscontroller.dart';

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    final Statuscontroller status = Get.find<Statuscontroller>();
    final Getx username = Get.find<Getx>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text("Updates"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(children: [Text("status", style: TextStyle(fontSize: 20))]),
            InkWell(
              onTap: () async {
                final firestore = await FirebaseFirestore.instance
                    .collection('status')
                    .doc(username.username.value)
                    .get();
                if (firestore.exists) {
                  final data = firestore.data();
                  Get.to(() => Mystatus(item: data!['item']));
                  return;
                }
                await status.statusvideochose();
              },
              child: Row(
                spacing: 15,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Text(
                          username.username.value.tr.split("").first,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0, left: 40),
                        child: CircleAvatar(
                          radius: 11,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.add, size: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add status",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text("Disappears after 24 hourse"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            StreamBuilder(
              stream: status.getstatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text("data"));
                }
                final data = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final data1 = data[index].data();
                    if (data1['username'] == username.username.value) {
                      return null;
                    }
                    return InkWell(
                      onTap: () {
                        Get.to(() => VideoApp(item: data1['item']));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Text(
                                data1['username'].toString().split('').first,
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            Text(
                              data1['username'],
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
