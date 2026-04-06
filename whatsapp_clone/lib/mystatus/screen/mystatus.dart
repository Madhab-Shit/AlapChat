import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traychat/controller/chatcontroller.dart';
import 'package:traychat/controller/singincontroler.dart';
import 'package:traychat/controller/statuscontroller.dart';
import 'package:traychat/mystatus/screen/mystoryplay.dart';
import 'package:traychat/story/story.dart';

class Mystatus extends StatefulWidget {
  final username;
  const Mystatus({super.key, required this.username});

  @override
  State<Mystatus> createState() => _MystatusState();
}

class _MystatusState extends State<Mystatus> {
  final Statuscontroller status = Get.find<Statuscontroller>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("My Status"), backgroundColor: Colors.white),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('status')
            .doc(widget.username)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text("No Data"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          List item = data['item'] ?? [];
          if (item.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.back();
            });
          }

          return ListView.builder(
            itemCount: item.length,
            itemBuilder: (context, index) {
              final image = item[index]['video'].toString();
              String cleanUrl;
              if (image.contains('.')) {
                // Shudhu jodi dot thake, tokhon shesh dot porjonto nibe
                cleanUrl = image.substring(0, image.lastIndexOf('.'));
              } else {
                cleanUrl = image;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5,
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => Mystoryplay(
                        item: image,
                        time: item[index]['createdAt'],
                        index: index,
                        username: widget.username,

                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          "${cleanUrl.toString()}.jpg",
                        ),
                      ),
                      PopupMenuButton(
                        onSelected: (value) async {
                          if (value == "Delete") {
                            var ref = FirebaseFirestore.instance
                                .collection('status')
                                .doc(widget.username);

                            var snapshot = await ref.get();

                            List items = snapshot['item'];

                            items.removeAt(index);

                            await ref.update({'item': items});
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(child: Text("delete"), value: "Delete"),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          await status.statusvideochose();
        },
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
