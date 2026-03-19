import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chatimageshow extends StatefulWidget {
  final String imagepath;
  final bool imageid;
  final String otherid;
  const Chatimageshow({
    super.key,
    required this.imagepath,
    required this.imageid,
    required this.otherid,
  });

  @override
  State<Chatimageshow> createState() => _ChatimageshowState();
}

class _ChatimageshowState extends State<Chatimageshow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          widget.imageid ? "You" : widget.otherid,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image.network(
          widget.imagepath,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child; 
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
