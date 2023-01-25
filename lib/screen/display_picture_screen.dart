// A widget that displays the picture taken by the user.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vary_recycle/screen/reward_screen.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  onConfirmTap() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(widget.imagePath
        .substring(60, 69)); // Storage에 저장될 때 파일 이름, 어떻게 설정해야할까..?
    File file = File(widget.imagePath);

    try {
      await imageRef.putFile(file);

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                const RewardScreen()), //이후에 이미지 분석해서 Reward or fail 분기점 만들기
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('플라스틱'), // 홈 화면에서 누른 위젯에 따라 변경 필요!
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: [
          Image.file(File(widget.imagePath)),
          const SizedBox(
            height: 50,
          ),
          const Text(
            '해당 사진으로 선택하시겠어요?',
            style: TextStyle(
              color: Colors.green,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  '다시 찍기',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: onConfirmTap, // 이미지 서버 storage로 보내기
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
