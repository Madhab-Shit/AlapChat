import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traychat/controller/statuscontroller.dart';
import 'package:traychat/mystatus/screen/mystoryplay.dart';
import 'package:traychat/story/story.dart';

class Mystatus extends StatefulWidget {
  final List item;
  const Mystatus({super.key, required this.item});

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
      body: ListView.builder(
        itemCount: widget.item.length,
        itemBuilder: (context, index) {
          final image = widget.item[index]['video'].toString();
          String cleanUrl;
          if (image.contains('.')) {
            // Shudhu jodi dot thake, tokhon shesh dot porjonto nibe
            cleanUrl = image.substring(0, image.lastIndexOf('.'));
          } else {
            cleanUrl = image;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: InkWell(
              onTap: () {
                Get.to(() => Mystoryplay(item: image));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage("${cleanUrl.toString()}.jpg"),
                  ),
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == "Delete") {
                        log("message");
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
