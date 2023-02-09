import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vary_recycle/screen/barcode_scan_screen.dart';
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
/*
class GetUserName extends StatelessWidget {
  final String documentId;
  const GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('user');

    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(documentId).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("asdf: ${data['credit']}");
        }
        return const Text("loading");
      },
    );
  }
}*/

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

  Future<String> ReturnValue(String info) async {
    final usercol = FirebaseFirestore.instance;
    final result = await usercol.collection('user').doc('$myUid').get();
    var list = result.data();
    return list?[info];
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

  Future addUserDetails(String userName, int credit, String userID) async {
    await FirebaseFirestore.instance.collection('users').add({
      'name': userName,
      'credit': credit,
      'userID': userID,
    });
  }

  @override
  Widget build(BuildContext context) {
    const int credit = 10000;
    late dynamic userName =
        FirebaseAuth.instance.currentUser?.displayName ?? "NaN";
    late dynamic userID = FirebaseAuth.instance.currentUser?.uid ?? "NaN";

    addUserDetails(userName, credit, userID);

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
          actions: [
            IconButton(
              onPressed: () {
                //ReturnValue('credit');
                //FirebaseAuth.instance.signOut();
              },
              icon: const Icon(
                Icons.favorite,
                size: 30,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Column(
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Transform(
              transform: Matrix4.translationValues(
                0,
                _translateButton.value * 4,
                0,
              ),
              child: SizedBox(
                width: 75,
                height: 75,
                child: FloatingActionButton(
                  heroTag: "email",
                  backgroundColor: Colors.green,
                  onPressed: () {},
                  child: const Icon(
                    size: 40,
                    Icons.email,
                  ),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0,
                _translateButton.value * 3,
                0,
              ),
              child: SizedBox(
                width: 75,
                height: 75,
                child: FloatingActionButton(
                  heroTag: "call",
                  backgroundColor: Colors.green,
                  onPressed: () {/* Do something */},
                  child: const Icon(
                    size: 40,
                    Icons.call,
                  ),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0,
                _translateButton.value * 2,
                0,
              ),
              child: SizedBox(
                width: 75,
                height: 75,
                child: FloatingActionButton(
                  heroTag: "message",
                  backgroundColor: Colors.green,
                  onPressed: () {/* Do something */},
                  child: const Icon(
                    Icons.message,
                    size: 40,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 15,
              ),
              child: SizedBox(
                height: 75,
                width: 75,
                child: FloatingActionButton(
                  heroTag: "menu",
                  backgroundColor: Colors.green,
                  onPressed: _toggle,
                  child: AnimatedIcon(
                    size: 40,
                    icon: AnimatedIcons.menu_close,
                    progress: _buttonAniatedIcon,
                  ),
                ),
              ),
            ),
          ],
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



/*
StreamBuilder(
          stream: product.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    child: ListTile(
                      title: Text(documentSnapshot['asdf']),
                    ),
                  );
                },
              );
            }
            return const CircularProgressIndicator();
          },
        ),*/