import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String recycleType;
  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.recycleType});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String result = 'Take Picture Again';

  Future<String> getResult() async {
    String server = "121.169.44.47";
    String restPort = "13285";
    var imageFile = File(widget.imagePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    final res = await http.post(
      Uri.parse('${'http://$server'}:$restPort/test'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {'type': widget.recycleType, 'image': base64Image}
      ]),
    );
    result = res.body;
    return res.body;
  }

  onConfirmTap() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(widget.imagePath
        .substring(60, 69)); // Storage에 저장될 때 파일 이름, 어떻게 설정해야할까..?
    File file = File(widget.imagePath);

    try {
      await imageRef.putFile(file);

      if (!mounted) return;
      // getResult();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return FutureBuilder(
              future: getResult(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // return RewardScreen(result: result);
                  return Scaffold(
                    body: Center(
                      child: Text(result),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              });
        },
      )
          //이후에 이미지 분석해서 Reward or fail 분기점 만들기
          );
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
                        fontSize: 30,
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
                        fontSize: 30,
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
