import 'package:flutter/material.dart';

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
            image: NetworkImage(
              "https://res.cloudinary.com/dfofmcmgt/image/upload/v1773192936/buwizg1rqlggzghvagmo.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
