import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vary_recycle/widgets/camera_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openCameraPage() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
                  camera: firstCamera,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'HOME SCREEN',
                style: TextStyle(fontSize: 32),
              ),
              IconButton(
                  iconSize: 100,
                  onPressed: _openCameraPage,
                  icon: const Icon(
                    Icons.recycling,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
