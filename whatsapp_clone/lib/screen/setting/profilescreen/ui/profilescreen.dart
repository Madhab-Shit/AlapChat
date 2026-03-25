import 'package:flutter/material.dart';
import 'package:traychat/chatprofile.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text("Profile")),
      body: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    getx.username.value.split('').first,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Edit",
                style: TextStyle(color: Color(0xff1EAB62), fontSize: 20),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.person_outline_sharp, size: 25),
                  title: Text(
                    "Name",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(
                    getx.username.value,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.call, size: 25),
                  title: Text(
                    "Phone",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(
                    getx.phone.value,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
