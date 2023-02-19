import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vary_recycle/screen/reward_screen.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String recycleType;
  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.recycleType});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  onConfirmTap() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(widget.imagePath
        .substring(60, 69)); // Storage에 저장될 때 파일 이름, 어떻게 설정해야할까..?
    File file = File(widget.imagePath);

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) {
            return RewardScreen(
              imagePath: widget.imagePath,
              recycleType: widget.recycleType,
            );
          },
          fullscreenDialog: true),
    );

    try {
      await imageRef.putFile(file);
      if (!mounted) return;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.recycleType.toUpperCase()), // 홈 화면에서 누른 위젯에 따라 변경 필요!
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(File(widget.imagePath)),
            ],
          ),
          Align(
            alignment: const Alignment(0, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 30,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "재촬영",
                      style: GoogleFonts.varelaRound(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: TextButton(
                    onPressed: onConfirmTap,
                    child: Text(
                      "확인",
                      style: GoogleFonts.varelaRound(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
