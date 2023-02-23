import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vary_recycle/screen/home_screen.dart';
import 'package:rive/rive.dart';

class RewardScreen extends StatefulWidget {
  final imagePath;
  final recycleType;
  const RewardScreen({
    super.key,
    this.imagePath,
    this.recycleType,
  });

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  Future<Map<String, dynamic>> getResult() async {
    String server = "121.169.44.47";
    String restPort = "13285";
    // var imageFile = File(widget.imagePath);

    File resizeFile = await FlutterNativeImage.compressImage(widget.imagePath,
        quality: 80, targetWidth: 640, targetHeight: 640);

    List<int> imageBytes = resizeFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    Map<String, dynamic> errorMsg = {};
    try {
      final res = await http
          .post(
            Uri.parse('${'http://$server'}:$restPort/test'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode([
              {
                'uid': ReturnId(),
                'type': widget.recycleType,
                'image': base64Image
              }
            ]),
          )
          .timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        if (res.body == 'SERVER_ERROR') {
          errorMsg['result'] = 'Error occured in server';
          return errorMsg;
        }
        Map<String, dynamic> info = jsonDecode(res.body);
        return info;
      } else {
        errorMsg['result'] = 'HTTP error occured in server';
        return errorMsg;
      }
    } catch (e) {
      errorMsg['result'] = 'Server not connected';
      return errorMsg;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: getResult(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            //Loading..
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!['result'] == 'success') {
            // 하나라도 성공
            return Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Congratulation!',
                      style: GoogleFonts.varelaRound(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'You got ${snapshot.data!['success'] * 30} credits',
                  style: GoogleFonts.varelaRound(
                    color: Colors.grey.shade600,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  width: 300,
                  height: 300,
                  child: RiveAnimation.asset(
                      "assets/RiveAssets/success_check2.riv"),
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Detected Object : ${snapshot.data!['success']}',
                        style: GoogleFonts.varelaRound(
                          color: Colors.grey.shade600,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Success                : ${snapshot.data!['success']}',
                        style: GoogleFonts.varelaRound(
                          color: Colors.grey.shade600,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('Fail                         : 0',
                          style: GoogleFonts.varelaRound(
                            color: Colors.grey.shade600,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const HomeScreen()),
                        (route) => false);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF00CA71),
                  ),
                  child: Text(
                    'OK',
                    style: GoogleFonts.varelaRound(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Try Again',
                      style: GoogleFonts.varelaRound(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (snapshot.data!['result'] == 'fail' && // 아무 예측도 못한 경우
                    snapshot.data!['detected_object'] == 0)
                  Text(
                    'No Object Detected',
                    style: GoogleFonts.varelaRound(
                      color: Colors.grey.shade600,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else if (snapshot
                            .data!['result'] ==
                        'Error occured in server' ||
                    snapshot.data!['result'] ==
                        'HTTP error occured in server' ||
                    snapshot.data!['result'] == 'Server not connected')
                  Text(
                    snapshot.data!['result'],
                    style: GoogleFonts.varelaRound(
                      color: Colors.grey.shade600,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    'Make sure recycle properly.', // 예측은 했는데 전부 fail로 분류된 경우
                    style: GoogleFonts.varelaRound(
                      color: Colors.grey.shade600,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(
                  width: 300,
                  height: 300,
                  child: RiveAnimation.asset("assets/RiveAssets/error.riv"),
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Detected Object : ${snapshot.data!['detected object']}',
                        style: GoogleFonts.varelaRound(
                          color: Colors.grey.shade600,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Success                : ${snapshot.data!['success']}',
                        style: GoogleFonts.varelaRound(
                          color: Colors.grey.shade600,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                          'Fail                         : ${snapshot.data!['fail']}',
                          style: GoogleFonts.varelaRound(
                            color: Colors.grey.shade600,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ))
                    ],
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
                        backgroundColor: const Color(0xFFFF6347),
                      ),
                      child: Text(
                        'Back',
                        style: GoogleFonts.varelaRound(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const HomeScreen()),
                            (route) => false);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6347),
                      ),
                      child: Text(
                        'Go main',
                        style: GoogleFonts.varelaRound(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}