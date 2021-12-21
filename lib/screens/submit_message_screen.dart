import 'package:flutter/material.dart';

class SubmitMessage extends StatefulWidget {
  const SubmitMessage({Key? key}) : super(key: key);

  @override
  _SubmitMessageState createState() => _SubmitMessageState();
}

class _SubmitMessageState extends State<SubmitMessage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Image(
        image: AssetImage('assets/goodjob.png'),
      )),
    );
  }
}
