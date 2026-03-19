import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traychat/chat.dart';
import 'package:traychat/controller/singincontroler.dart';

class Chatprofile extends StatefulWidget {
  const Chatprofile({super.key});

  @override
  State<Chatprofile> createState() => _ChatprofileState();
}

Getx getx = Get.find<Getx>();

class _ChatprofileState extends State<Chatprofile> {
  late SharedPreferences? Username;
  late SharedPreferences? sp;
  Future<void> setname() async {
    final SharedPreferences Username = await SharedPreferences.getInstance();
    getx.username.value = Username.getString('name') ?? '';
    log(getx.username.toString());
  }

  Future<void> setlogin() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('sc', false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setname();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("New Chat"),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 10.0),
        //     child: PopupMenuButton(
        //       onSelected: (value) {
        //         if (value == "Logout") {
        //           setlogin();
        //           getx.singin.value = true;
        //           Get.offAll(() => Login());
        //         }
        //       },
        //       itemBuilder: (BuildContext context) => [
        //         PopupMenuItem(value: "share", child: Text("Share")),
        //         PopupMenuItem(value: 'Setting', child: Text("Setting")),
        //         PopupMenuItem(value: 'Logout', child: Text("Logout")),
        //       ],
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(254, 215, 212, 212),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.search),
                    Text("Search", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final users = snapshot.data!.docs
                          .where((doc) => doc['uid'] != getx.username.value)
                          .toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];

                          return InkWell(
                            onTap: () {
                              Get.off(
                                Chat(
                                  profileicon: user['uid'][0],
                                  myid: getx.username.value,
                                  otherUserId: user['uid'],
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    child: Text(
                                      user['uid'][0],
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    user['uid'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
