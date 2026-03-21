import 'package:flutter/material.dart';

class Contectview extends StatefulWidget {
  final String name;
  final String phone;
  const Contectview({super.key, required this.phone, required this.name});

  @override
  State<Contectview> createState() => _ContectviewState();
}

class _ContectviewState extends State<Contectview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(117, 255, 255, 255),
        title: Text("View contact"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: Colors.white,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      child: Text(widget.name.toString().split("").first),
                    ),
                    Text(widget.name, style: TextStyle(fontSize: 18)),
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
                    Text(widget.phone),
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
      ),
    );
  }
}
