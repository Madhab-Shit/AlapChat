import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traychat/story/story.dart';
import 'package:traychat/test.dart';

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
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
                // Get.to(() => VideoEditScreen());
                final XFile? galleryVideo = await picker.pickVideo(
                  source: ImageSource.gallery,
                );
                File file = File(galleryVideo!.path);
                Get.to(() => statusvideo(file: file));
              },
              child: Row(
                spacing: 15,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(radius: 30),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => VideoApp());
        },
        child: Icon(Icons.golf_course),
      ),
    );
  }
}
