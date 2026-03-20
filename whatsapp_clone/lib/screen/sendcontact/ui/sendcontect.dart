import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traychat/screen/sendcontact/controller/contactstore.dart';

class Sendcontect extends StatefulWidget {
  final List contectcount;
  final String myid;
  final String otherid;
  const Sendcontect({
    super.key,
    required this.contectcount,
    required this.myid,
    required this.otherid,
  });

  @override
  State<Sendcontect> createState() => _SendcontectState();
}

class _SendcontectState extends State<Sendcontect> {
  Contactstore contactsend = Get.put(Contactstore());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text("Send Contacts"),
      ),
      body: ListView.builder(
        itemCount: widget.contectcount.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Colors.white,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          child: Text(
                            widget.contectcount[index]['name']
                                .toString()
                                .split("")
                                .first,
                          ),
                        ),
                        Text(
                          widget.contectcount[index]['name'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Divider(color: const Color.fromARGB(55, 91, 88, 88)),
                    Row(
                      spacing: 20,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Icon(Icons.call),
                        ),
                        Text(widget.contectcount[index]['phone']),
                        Spacer(),
                        Checkbox(
                          activeColor: Colors.green,
                          value: true,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff34B271),
        onPressed: () {
          Get.back();
          Get.back();
          contactsend.chatdata(
            widget.myid,
            widget.otherid,
            widget.contectcount,
          );
        },
        child: Icon(Icons.send, color: Colors.white),
      ),
    );
  }
}
