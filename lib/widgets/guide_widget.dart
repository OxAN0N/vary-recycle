import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class GuideSlider extends StatefulWidget {
  final String recycleType;

  const GuideSlider({super.key, required this.recycleType});

  @override
  State<GuideSlider> createState() => _GuideSliderState();
}

class _GuideSliderState extends State<GuideSlider>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool upDown = true;
  final CarouselController carouselController = CarouselController();

  Future<List<String>> getFileNamesFromAssetsFolder(String folderName) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    List<String> fileNames = [];

    for (var key in manifestMap.keys) {
      if (key.startsWith('assets/$folderName/')) {
        String fileName = key.replaceAll('assets/$folderName/', '');
        fileNames.add(fileName);
      }
    }
    return fileNames;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.linear),
    );
  }

  void _up() {
    print(_animation.value);
    setState(() {
      if (upDown) {
        upDown = false;
        _controller.forward(from: 0.0);
      } else {
        upDown = true;
        _controller.reverse(from: 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final ui.Size logicalSize = MediaQuery.of(context).size;
    double width = 400;
    double height = 400;
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              top: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recycleType.toUpperCase(),
                  style: GoogleFonts.varelaRound(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Text(
                    "Tap button to see guide",
                    style: GoogleFonts.varelaRound(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: GestureDetector(
              onTap: _up,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 77, 183, 245),
                ),
                child: const Icon(
                  size: 35,
                  Icons.recycling_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      GestureDetector(
          onTap: _up,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                height: height * _animation.value,
                width: width,
                child: FutureBuilder<List<String>>(
                  future: getFileNamesFromAssetsFolder(
                      '${widget.recycleType.toUpperCase()}_guide'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: height,
                          scrollDirection: Axis.horizontal,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                        ),
                        items: snapshot.data!.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Image.asset(
                                'assets/${widget.recycleType.toUpperCase()}_guide/$i',
                                fit: BoxFit.fitWidth,
                              );
                            },
                          );
                        }).toList(),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              );
            },
          )),
    ]);
  }
}
