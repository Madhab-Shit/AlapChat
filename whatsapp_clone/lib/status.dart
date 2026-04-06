import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traychat/controller/singincontroler.dart';
import 'package:traychat/mystatus/screen/mystatus.dart';
import 'package:traychat/story/story.dart';

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
                  Get.to(() => Mystatus(username: username.username.value));
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
                final data1 = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data1.length,
                  itemBuilder: (context, index) {
                    var data = data1[index].data();

                    List items = data['item'];
                    for (var i = 0; i < items.length; i++) {
                      if (!items[i]['expiresAt'].toDate().isAfter(
                        DateTime.now(),
                      )) {
                        items.removeAt(i);
                        var ref = FirebaseFirestore.instance
                            .collection('status')
                            .doc(data['username']);
                        ref.update({'item': items});
                      }
                    }

                    if (items.isEmpty) {
                      FirebaseFirestore.instance
                          .collection('status')
                          .doc(data['username'])
                          .delete();
                      return SizedBox();
                    }
                    if (data['username'] == username.username.value) {
                      return SizedBox();
                    }

                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => VideoApp(
                            item: data['item'],
                            name: data['username'],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Text(
                                data['username'].toString().split('').first,
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            Text(
                              data['username'],
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
