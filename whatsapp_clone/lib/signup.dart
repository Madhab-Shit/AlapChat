import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traychat/chatprofile.dart';
import 'package:traychat/controller/singincontroler.dart';
import 'package:traychat/recentchat.dart';

Getx getx = Get.find<Getx>();
final _from = GlobalKey<FormState>();
final name = TextEditingController();
final reuserid = TextEditingController();
final number = TextEditingController();
final repassword = TextEditingController();
final reconpassword = TextEditingController();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> loginUsername(String name1) async {
  final SharedPreferences Signupusername =
      await SharedPreferences.getInstance();
  await Signupusername.setString('name', name1);
}

Future<void> signupUser(String uid, String phone, String password) async {
  final docRef = _firestore.collection('users').doc(phone);
  final id = _firestore.collection('users').doc(uid);
  final userid = await id.get();
  final snapshot = await docRef.get();

  if (userid.exists) {
    Get.snackbar('Error', 'User ID already exists');
    return;
  }

  if (snapshot.exists) {
    Get.snackbar('Error', 'Phone Number already exists');
    return;
  }

  await docRef.set({
    'uid': uid,
    'phone': phone,
    'password': password,
    'createdAt': FieldValue.serverTimestamp(),
  });

  Get.snackbar('Success', 'Signup Successful');
  Get.offAll(Recentchat());
}

Widget singup() {
  return Column(
    spacing: 20,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: 30),
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Enter your details to join the community.",
                style: TextStyle(
                  color: Color(0xffAA9B91),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 20),

      Form(
        key: _from,
        child: Column(
          spacing: 20,
          children: [
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(color: Color(0xffC3B9B0)),
                prefixIcon: Icon(Icons.person, color: Color(0xffC3B9B0)),
                filled: true,
                fillColor: Color.fromARGB(57, 185, 184, 184),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter Name";
                }
              },
            ),
            TextFormField(
              controller: number,
              decoration: InputDecoration(
                hintText: "Mobile Nmber",
                hintStyle: TextStyle(color: Color(0xffC3B9B0)),
                prefixIcon: Icon(Icons.call, color: Color(0xffC3B9B0)),
                filled: true,
                fillColor: Color.fromARGB(57, 185, 184, 184),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter Mobile Number";
                } else if (value.length != 10) {
                  return "Moble Number Not Currect";
                }
              },
            ),
            TextFormField(
              controller: reuserid,
              decoration: InputDecoration(
                hintText: "Username",
                hintStyle: TextStyle(color: Color(0xffC3B9B0)),
                filled: true,
                fillColor: Color.fromARGB(57, 185, 184, 184),
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: Color(0xffC3B9B0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter Userneame";
                }
              },
            ),
            TextFormField(
              controller: repassword,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Color(0xffC3B9B0)),
                filled: true,
                fillColor: Color.fromARGB(57, 185, 184, 184),
                prefixIcon: Icon(Icons.lock, color: Color(0xffC3B9B0)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter Password";
                } else if (value.length < 6) {
                  return "Must be password 6 Character";
                }
              },
            ),
            TextFormField(
              controller: reconpassword,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                hintStyle: TextStyle(color: Color(0xffC3B9B0)),
                filled: true,
                fillColor: Color.fromARGB(57, 185, 184, 184),
                prefixIcon: Icon(Icons.security, color: Color(0xffC3B9B0)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromARGB(57, 185, 184, 184),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter Confirm Password";
                } else if (value != repassword.text) {
                  return "Password Not match";
                }
              },
            ),
          ],
        ),
      ),

      Container(
        margin: EdgeInsets.only(top: 30),
        width: 250,
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(5),
            ),
          ),

          onPressed: () {
            if (_from.currentState!.validate()) {
              loginUsername(reuserid.text);

              signupUser(reuserid.text, number.text, repassword.text);
              name.clear();
              reuserid.clear();
              number.clear();
              repassword.clear();
              reconpassword.clear();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create Account",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Icon(Icons.arrow_forward, color: Colors.white, size: 25),
            ],
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an Account? ",
            style: TextStyle(
              color: Color(0xff907675),
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () {
              getx.singin.value = !getx.singin.value;
            },
            child: Text(
              "Sing In",
              style: TextStyle(
                color: Color(0xff2A54B6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
