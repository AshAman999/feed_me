import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 600,
            ),
            ElevatedButton(
              onPressed: () {
                // navigate to the next screen
                Navigator.pushNamed(context, '/imagePicker');
              },
              child: const Text(
                'Share your meal',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(15)),
            )
          ],
        ),
      ),
    );
  }
}
