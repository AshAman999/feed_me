import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:random_string/random_string.dart';

import 'notification_click_screen.dart';
import 'submit_message_screen.dart';

class ImagePicker extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const ImagePicker({
    this.cameras,
    Key? key,
  }) : super(key: key);

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late CameraController controller;
  XFile? pictureFile;
  @override
  void initState() {
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.medium,
    );
    controller.initialize().then(
      (_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      },
    );
    super.initState();
    requestPermissions();
    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = const IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    var initSetttings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSetttings,
      onSelectNotification: (payload) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NotificationClickScreen(
              imgurl: payload!,
            ),
          ),
        );
      },
    );
    // To display the current output from the Camera,
  }

  void requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  showSimpleNotification(String imgurl) async {
    var androidDetails = const AndroidNotificationDetails(
      'id',
      'channel ',
      channelDescription: 'channelDescription',
      priority: Priority.high,
      importance: Importance.max,
    );
    var iOSDetails = const IOSNotificationDetails();
    var platformDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Feed Me',
      'Mmmm 😋, Thanks,the food was really delicious !!!',
      platformDetails,
      payload: imgurl,
    );
  }

  // Future onClickNotification(String payload) {
  //   // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
  //   //   return null;
  //   // }));
  //   return
  //   print('I am clicked');
  // }

  @override
  void dispose() {
    pictureFile = null;
    controller.dispose();
    // Dispose of the controller when the widget is disposed.
    super.dispose();
  }

  String instruction = "Click your meal";
  IconData useicon = Icons.camera_alt_outlined;
  bool isLoading = false;
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
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 30,
            ),
            // ignore: avoid_unnecessary_containers
            Container(
              // margin: const EdgeInsets.only(bottom: 10),
              child: const Image(image: AssetImage('assets/baby.png')),
            ),
            Expanded(
              child: Container(
                // margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    // bottomRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0),
                    bottomLeft: Radius.circular(0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Image(
                          image: AssetImage('assets/fork.png'),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          height: 150,
                          width: 150,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: (!controller.value.isInitialized)
                              ? const SizedBox(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      150,
                                    ),
                                    child: SizedBox(
                                      height: 400,
                                      width: 400,
                                      child: pictureFile == null
                                          ? CameraPreview(controller)
                                          : Image(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                  File(pictureFile!.path),
                                                  scale: 1),
                                            ),
                                    ),
                                  ),
                                ),
                        ),
                        const ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                          // child: AspectRatio(
                          //   aspectRatio: 1,
                          //   child: CameraPreview(controller),

                          // ),
                        ),
                        const Image(
                          image: AssetImage('assets/spoon.png'),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Text(
                        instruction,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (useicon == Icons.check) {
                          setState(() {
                            isLoading = true;
                          });
                          final refr = FirebaseStorage.instance.ref(
                              "uploadedImages/${randomAlphaNumeric(8)}.jpg");
                          final task = refr.putFile(File(pictureFile!.path));
                          final snapshot = await task.whenComplete(() {});
                          var imglink = await snapshot.ref.getDownloadURL();
                          setState(() {
                            pictureFile = null;
                          });
                          await showSimpleNotification(imglink);
                          debugPrint(imglink);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SubmitMessage(),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          pictureFile = await controller.takePicture();
                          setState(() {
                            // ignore: avoid_print
                            print(pictureFile!.path);
                          });
                          setState(
                            () {
                              instruction = 'Will you eat this?';
                              useicon = Icons.check;
                              isLoading = false;
                            },
                          );
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.green,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 25,
                              child: Icon(
                                useicon,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
