import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traychat/chatprofile.dart';
import 'package:traychat/controller/singincontroler.dart';
import 'package:traychat/recentchat.dart';
import 'package:traychat/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

Getx getx = Get.find<Getx>();
SharedPreferences? sp;
SharedPreferences? name;

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _initPrefs() async {
    sp = await SharedPreferences.getInstance();
    await sp?.setBool('sc', true);
    log(getx.privay.toString());
  }

  Future<void> loginUsername(String name1) async {
    final SharedPreferences name = await SharedPreferences.getInstance();
    await name.setString('name', name1);
  }

  Future<void> loginUser(String uid, String password) async {
    final docRef = _firestore.collection('users').doc(uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      Get.snackbar('Error', 'User not found');
      return;
    }

    final data = snapshot.data()!;
    if (data['password'] != password) {
      Get.snackbar('Error', 'Wrong password');
      return;
    }

    Get.snackbar('Success', 'Login Successful');
    log(data['phone']);
    Get.offAll(Recentchat());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Obx(
                  () => getx.singin.value
                      ? Column(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Color(0xff2A54B6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                spacing: 20,
                                children: [
                                  TextFormField(
                                    controller: username,
                                    decoration: InputDecoration(
                                      hintText: "UserName",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter Userneame";
                                      } else {
                                        loginUsername(username.text);
                                        getx.username.value = username.text;
                                        log(getx.username.toString());
                                      }
                                    },
                                  ),
                                  TextFormField(
                                    controller: password,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter Userneame";
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Frogot Your Password",
                                  style: TextStyle(
                                    color: Color(0xff2A54B6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              width: 130,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color(0xffFF9325),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      5,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _initPrefs();

                                    loginUser(username.text, password.text);
                                  }
                                },
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: Color(0xff2A54B6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    getx.singin.value = !getx.singin.value;
                                    log(getx.singin.toString());
                                  },
                                  child: Text(
                                    "Sing Up",
                                    style: TextStyle(
                                      color: Color(0xff2A54B6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : singup(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
