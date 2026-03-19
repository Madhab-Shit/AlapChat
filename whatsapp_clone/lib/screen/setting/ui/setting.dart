import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traychat/screen/setting/profilescreen/ui/profilescreen.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  List data = [
    {'Icon': Icons.person, 'name': 'Profile'},
    {'Icon': Icons.chat, 'name': 'Chats'},
    {'Icon': Icons.help_outline, 'name': 'Help & Feedback'},
    {'Icon': Icons.family_restroom_outlined, 'name': 'Invite a Friend'},
    {'Icon': Icons.delete, 'name': 'Delete account'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text("Setting")),
      body: ListView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Get.to(() => Profilescreen());
              }
            },
            child: ListTile(
              leading: Icon(data[index]['Icon']),
              title: Text(data[index]['name']),
            ),
          );
        },
      ),
    );
  }
}
