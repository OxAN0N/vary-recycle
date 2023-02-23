import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vary_recycle/screen/home_screen.dart';
import 'package:vary_recycle/screen/take_picture_screen.dart';

class Recycle_item extends StatefulWidget {
  const Recycle_item({
    super.key,
    required this.name,
  });

  final String name;
  @override
  State<Recycle_item> createState() => _Recycle_itemState();
}

class _Recycle_itemState extends State<Recycle_item> {
  void _openCameraPage(String recycleType) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
                  camera: firstCamera,
                  recycleType: recycleType,
                )));
  }

  void _openBarcodeScanner() {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: ((context) => const QrBarcodeScanner(
    //               title: "QR/Barcode",
    //             ))));
  }

  Future<Duration> TimeCheck() async {
    final instance = FirebaseFirestore.instance;
    final time = await instance.collection('user').doc('$myUid').get();
    var list = time.data();
    Timestamp RecordedTime = list?['currentReq'];
    var recordTime = DateTime.fromMicrosecondsSinceEpoch(
        RecordedTime.microsecondsSinceEpoch);
    var diff = DateTime.now().difference(recordTime);
    return diff;
  }

  Future<int> lifeCheck() async {
    final instance = FirebaseFirestore.instance;
    final life = await instance.collection('user').doc('$myUid').get();
    var list = life.data();
    int restLife = list?['countPerDay'];
    return restLife;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(17),
      child: Column(
        children: [
          IconButton(
            iconSize: 80,
            onPressed: () async {
              var diff = await TimeCheck();
              var chance = await lifeCheck();
              print(chance);
              if (chance >= 5) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text(
                        "Your remain chance is over today!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        Center(
                          child: TextButton(
                            child: const Text(
                              "OK",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else if (diff.inHours >= 2) {
                _openCameraPage(widget.name);
              } else {
                int hour = 120;
                int minute;
                hour = hour - diff.inMinutes;
                minute = hour % 60;
                hour = hour ~/ 60;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(
                        "You can try it after $hour hours $minute mintues!",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        Center(
                          child: TextButton(
                            child: const Text(
                              "OK",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            icon: Image.asset(
              "assets/HOME_page/${widget.name}.png",
            ),
          ),
          Text(
            widget.name.toUpperCase(),
            style: GoogleFonts.varelaRound(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
