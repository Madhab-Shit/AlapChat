import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traychat/controller/chatcontroller.dart';
import 'package:traychat/controller/singincontroler.dart';

class GalleryPickerPage extends StatefulWidget {
  final String myid;
  final String otherid;

  const GalleryPickerPage({
    super.key,
    required this.myid,
    required this.otherid,

  });
  @override
  _GalleryPickerPageState createState() => _GalleryPickerPageState();
}

class _GalleryPickerPageState extends State<GalleryPickerPage> {
  Getx getx = Get.find<Getx>();
  Chatcontroller chat = Get.put(Chatcontroller());
  final TextEditingController sendsms = TextEditingController();

  final FirebaseFirestore chartdata = FirebaseFirestore.instance;
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Gallery Access", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(child: Image.file(chat.file, fit: BoxFit.cover)),
          ),

          // Input area at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Row(
                      children: [
                        // getx.showEmoji.value
                        //     ? InkWell(
                        //       onTap: () {
                        //         getx.showEmoji.value = !getx.showEmoji.value;
                        //       },
                        //       child: Icon(Icons.keyboard))
                        //     : Icon(Icons.emoji_emotions_outlined),
                        InkWell(
                          onTap: () {
                            if (!getx.showEmoji.value) {
                              FocusScope.of(context).unfocus();
                            } else {
                              focusNode.requestFocus();
                            }
                            setState(() {
                              getx.showEmoji.value = !getx.showEmoji.value;
                            });
                          },
                          child: Icon(
                            getx.showEmoji.value
                                ? Icons.keyboard
                                : Icons.emoji_emotions_outlined,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: chat.voice.value
                              ? Text(chat.countvoice.toString())
                              : TextFormField(
                                  controller: sendsms,
                                  decoration: InputDecoration(
                                    hintText: "Message",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      chat.chat.value = false;
                                    } else {
                                      chat.chat.value = true;
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.green,
                  child: InkWell(
                    onTap: () async {
                      Get.back();
                      String? dataimage = await chat.uploadImage(chat.file);
                      log(dataimage.toString());
                      chat.chatimage(
                        widget.myid,
                        widget.otherid,
                        dataimage!.tr,
                      );
                    },
                    child: Icon(Icons.send, color: Colors.white, size: 26),
                  ),
                ),
              ],
            ),
          ),

          if (getx.showEmoji.value)
            SizedBox(
              height: 280,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  sendsms.text += emoji.emoji;
                  chat.chat.value = true;
                },
              ),
            ),
        ],
      ),
    );
  }
}
