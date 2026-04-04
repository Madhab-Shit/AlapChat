import 'dart:developer';

import 'package:flutter/material.dart';

class Mystatus extends StatefulWidget {
  final List item;
  const Mystatus({super.key, required this.item});

  @override
  State<Mystatus> createState() => _MystatusState();
}

class _MystatusState extends State<Mystatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Status")),
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
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage("${cleanUrl.toString()}.jpg"),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text("data")),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
