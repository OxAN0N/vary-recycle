import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vary_recycle/screen/User_page.dart';
import 'package:vary_recycle/screen/barcode_scan_screen.dart';
import 'package:vary_recycle/screen/settings_page.dart';
import 'package:vary_recycle/screen/take_picture_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final myUid = user?.uid;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController SearchWord = TextEditingController();
  FocusNode textFoucs = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _buttonAniatedIcon;
  late Animation<double> _translateButton;
  late GoogleSignInAuthentication googleAuth;
  CollectionReference product = FirebaseFirestore.instance.collection('user');

  bool _isExpanded = false;

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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => const QrBarcodeScanner(
                  title: "QR/Barcode",
                ))));
  }

  Future<dynamic> ReturnValue(String info) async {
    final usercol = FirebaseFirestore.instance;
    final result = await usercol.collection('user').doc('$myUid').get();
    var list = result.data();
    return list?[info];
  }

  Future addUserDetails(
    String userName,
    int credit,
  ) async {
    final usercol = FirebaseFirestore.instance;
    final result = await usercol.collection('user').doc('$myUid').get();
    if (result.data() == null) {
      await FirebaseFirestore.instance.collection('user').doc('$myUid').set({
        'name': userName,
        'credit': credit,
      });
    }
  }

  @override
  void initState() {
    SearchWord.addListener(_printSearchText);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() {
        setState(() {});
      });

    _buttonAniatedIcon =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _translateButton = Tween<double>(
      begin: 100,
      end: -20,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _printSearchText() {
    print("print Search field ${SearchWord.text}");
  }

  _toggle() {
    if (_isExpanded) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    _isExpanded = !_isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    late dynamic userName =
        FirebaseAuth.instance.currentUser?.displayName ?? "NaN";
    addUserDetails(userName, 18274972);

    return GestureDetector(
      onTap: () {
        textFoucs.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 10,
          backgroundColor: Colors.green,
          title: const Text(
            'Vary Recycle',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        endDrawer: Drawer(
          elevation: 16.0,
          child: Column(children: <Widget>[
            UserAccountsDrawerHeader(
              onDetailsPressed: () {
                print('press details');
              },
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              accountName: Text(userName),
              accountEmail:
                  Text(FirebaseAuth.instance.currentUser?.email ?? "NaN"),
              currentAccountPicture: CircleAvatar(
                radius: 10.0,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.network(
                    FirebaseAuth.instance.currentUser?.photoURL ?? "NaN",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              otherAccountsPictures: const <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text("abc"),
                ),
              ],
            ),
            ListTile(
              title: const Text("Setting"),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingPage()));
              },
            ),
            ListTile(
              title: const Text("Profile"),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const UserPage()));
              },
            ),
            const SizedBox(
              height: 320,
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            )
          ]),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        child: Search_Area(
                            textFoucs: textFoucs, SearchWord: SearchWord),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        iconSize: 40,
                        onPressed: _openBarcodeScanner,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            iconSize: 120,
                            onPressed: () => _openCameraPage('paper'),
                            icon: Image.asset(
                              "assets/plastic.png",
                            ),
                          ),
                          const Text(
                            'paper',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            iconSize: 100,
                            onPressed: () => _openCameraPage('can'),
                            icon: Image.asset(
                              "assets/can.png",
                            ),
                          ),
                          const Text(
                            'can',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            iconSize: 120,
                            onPressed: () => _openCameraPage('glass'),
                            icon: Image.asset(
                              "assets/glass.png",
                            ),
                          ),
                          const Text(
                            'glass',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            iconSize: 110,
                            onPressed: () => _openCameraPage('pet'),
                            icon: Image.asset(
                              "assets/pet.png",
                            ),
                          ),
                          const Text(
                            'pet',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              bottom: 20,
                            ),
                            child: FutureBuilder(
                              future: ReturnValue('name'),
                              builder: (context, snapshot) {
                                if (snapshot.hasData == false) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text("error");
                                } else {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500),
                                  );
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.attach_money_outlined,
                                  size: 50,
                                ),
                                FutureBuilder(
                                  future: ReturnValue('credit'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData == false) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return const Text("error");
                                    } else {
                                      return Text(
                                        "${snapshot.data}",
                                        style: const TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'your percentage in month',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  height: 10,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Search_Area extends StatelessWidget {
  const Search_Area({
    Key? key,
    required this.textFoucs,
    required this.SearchWord,
  }) : super(key: key);

  final FocusNode textFoucs;
  final TextEditingController SearchWord;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: textFoucs,
      textInputAction: TextInputAction.go,
      onSubmitted: (value) {
        textFoucs.unfocus();
      },
      controller: SearchWord,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        labelText: "Search",
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.green,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Icon(
            Icons.search,
            color: Colors.black,
            size: 35,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: SearchWord.clear,
          icon: const Icon(
            Icons.cancel,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
