import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traychat/chat.dart';
import 'package:traychat/chatprofile.dart';
import 'package:traychat/controller/chatcontroller.dart';
import 'package:traychat/login.dart' hide getx;
import 'package:traychat/screen/setting/ui/setting.dart';

class Recentchat extends StatefulWidget {
  const Recentchat({super.key});

  @override
  State<Recentchat> createState() => _RecentchatState();
}

class _RecentchatState extends State<Recentchat> {
  Future<void> setlogin() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('sc', false);
  }

  final chatcontroller chat = Get.put(chatcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // leading: Text(""),
        title: Text("ALAP"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: PopupMenuButton(
              onSelected: (value) {
                if (value == "Logout") {
                  setlogin();
                  getx.singin.value = true;
                  Get.offAll(() => Login());
                } else if (value == 'Setting') {
                  Get.to(() => Setting());
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(value: "share", child: Text("Share")),
                PopupMenuItem(value: 'Setting', child: Text("Setting")),
                PopupMenuItem(value: 'Logout', child: Text("Logout")),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xffF5F5F2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        hintText: "Search",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chat.recentprofile(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No Chats Found"));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;
                    String ui = data['receiver'];
                    List<String> madhab = ui.split('_');
                    String finaldata = "";
                    if (getx.username.value == madhab[0]) {
                      finaldata = madhab[1];
                    } else if (getx.username.value == madhab[1]) {
                      finaldata = madhab[0];
                    }
                    if (finaldata.isEmpty) {
                      return Text("");
                    }

                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => Chat(
                            profileicon: finaldata[0],
                            myid: getx.username.value,
                            otherUserId: finaldata,
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          child: Text(
                            finaldata[0],
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        title: Text(
                          finaldata,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Get.to(() => Chatprofile());
        },
        child: Icon(Icons.add_comment, color: Colors.white, size: 30),
      ),
    );
  }
}
