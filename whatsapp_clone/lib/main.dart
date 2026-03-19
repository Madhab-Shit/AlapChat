import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traychat/chatprofile.dart';
import 'package:traychat/controller/singincontroler.dart';
import 'package:traychat/login.dart' hide getx;
import 'package:traychat/navigationpage.dart';
import 'package:traychat/recentchat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(Getx());
  runApp(MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late SharedPreferences sp;
  Future login() async {
    final sp = await SharedPreferences.getInstance();
    //  sp.remove('sc');
    getx.privay.value = sp.getBool('sc') ?? false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // home: Login(),
      home: getx.privay.value ? Navigationpage() : Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
