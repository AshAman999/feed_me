import 'package:flutter/material.dart';

class NotificationClickScreen extends StatelessWidget {
  final String imgurl;
  const NotificationClickScreen({Key? key, required this.imgurl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: 10,
            child: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: Image(
          image: NetworkImage(imgurl),
        ),
      ),
    );
  }
}
