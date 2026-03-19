import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traychat/calls.dart';
import 'package:traychat/controller/singincontroler.dart';
import 'package:traychat/recentchat.dart';
import 'package:traychat/status.dart';

class Navigationpage extends StatefulWidget {
  const Navigationpage({super.key});

  @override
  State<Navigationpage> createState() => _NavigationpageState();
}

class _NavigationpageState extends State<Navigationpage> {
  final Getx getx = Get.find<Getx>();

  late SharedPreferences? Username;
  late SharedPreferences? sp;
  Future<void> setname() async {
    final SharedPreferences Username = await SharedPreferences.getInstance();
    getx.username.value = Username.getString('name') ?? '';
    log(getx.username.toString());
  }

  int index = 0;
  List pagecall = [Recentchat(), Status(), Calls()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pagecall[index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {});
          index = value;
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chat'),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
        ],
      ),
    );
  }
}
