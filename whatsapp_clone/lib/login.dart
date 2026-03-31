import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traychat/controller/singincontroler.dart';
import 'package:traychat/navigationpage.dart';
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

  Future<void> loginPhone(String phone) async {
    final SharedPreferences phon = await SharedPreferences.getInstance();
    await phon.setString('phone', phone);
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

    loginUsername(data['uid']);
    loginPhone(uid);
    // getx.phone.value = uid;
    // log(getx.phone.value);
    // getx.username.value = data['uid'];
    Get.offAll(Navigationpage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Obx(
              () => getx.singin.value
                  ? Column(
                      children: [
                        SizedBox(height: 80),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back",
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Securely access your Luminous account.",
                              style: TextStyle(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 750,
                        ),

                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 20,
                                spreadRadius: 1,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            spacing: 10,
                            children: [
                              Form(
                                key: _formKey,
                                child: Column(
                                  spacing: 20,
                                  children: [
                                    TextFormField(
                                      controller: username,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "Phone Number",

                                        hintStyle: TextStyle(
                                          color: Color(0xffC3B9B0),
                                        ),

                                        prefixIcon: Icon(
                                          Icons.call,
                                          color: Color(0xffC3B9B0),
                                        ),
                                        filled: true,
                                        fillColor: Color.fromARGB(
                                          57,
                                          185,
                                          184,
                                          184,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                              57,
                                              185,
                                              184,
                                              184,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        border: InputBorder.none,
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.red,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                              57,
                                              185,
                                              184,
                                              184,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                              57,
                                              185,
                                              184,
                                              184,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter Userneame";
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: password,
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                          color: Color(0xffC3B9B0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Color(0xffC3B9B0),
                                        ),
                                        filled: true,
                                        fillColor: Color.fromARGB(
                                          57,
                                          185,
                                          184,
                                          184,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                              57,
                                              185,
                                              184,
                                              184,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.red,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                              57,
                                              185,
                                              184,
                                              184,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                              57,
                                              185,
                                              184,
                                              184,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter Userneame";
                                        }
                                        return null;
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
                                      color: Color(0xff485ED6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff5B86E5),
                                      Color(0xff36D1DC), // light orange
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),

                                  // color: Color(0xffFF9325),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shape: BeveledRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await _initPrefs();

                                      loginUser(username.text, password.text);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "LOGIN",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color: Color(0xff6D6D70),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      getx.singin.value = !getx.singin.value;
                                    },
                                    child: Text(
                                      "Sing Up",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff485ED6),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : singup(),
            ),
          ),
        ),
      ),
    );
  }
}
