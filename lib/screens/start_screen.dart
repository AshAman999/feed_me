import 'package:camera/camera.dart';
import 'package:feed_me/screens/image_click_screen.dart';
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
                availableCameras().then(
                  (value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePicker(cameras: value),
                    ),
                  ),
                );
                // navigate to the next screen
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
