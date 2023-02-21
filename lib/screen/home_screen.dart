import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vary_recycle/screen/User_page.dart';
import 'package:vary_recycle/screen/settings_page.dart';
import 'package:vary_recycle/screen/take_picture_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vary_recycle/widgets/recycle_life.dart';
import 'package:vary_recycle/widgets/recycle_item.dart';

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
  late GoogleSignInAuthentication googleAuth;
  CollectionReference product = FirebaseFirestore.instance.collection('user');

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
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late dynamic userName =
        FirebaseAuth.instance.currentUser?.displayName ?? "NaN";
    addUserDetails(userName, 0);

    return GestureDetector(
      onTap: () {
        textFoucs.unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            size: 30,
            color: Color.fromARGB(255, 107, 255, 112),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        endDrawer: Drawer(
          elevation: 16.0,
          child: Column(children: <Widget>[
            UserAccountsDrawerHeader(
              onDetailsPressed: () {},
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
            const Expanded(child: ListTile()),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            )
          ]),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                  'assets/—Pngtree—green background material for garbage_1194152.jpg'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                const Expanded(
                  child: RecycleLife(),
                ),
                Expanded(
                  flex: 1,
                  child: FutureBuilder(
                    future: ReturnValue('name'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text("error");
                      } else {
                        return Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            '${snapshot.data}',
                            style: GoogleFonts.varelaRound(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FutureBuilder(
                    future: ReturnValue('credit'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text("error");
                      } else {
                        return Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            '+ ${snapshot.data}%',
                            style: GoogleFonts.varelaRound(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 107, 255, 112),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FutureBuilder(
                    future: ReturnValue('credit'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text("error");
                      } else {
                        return Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            '\$${snapshot.data}',
                            style: GoogleFonts.varelaRound(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "your credit",
                        style: GoogleFonts.varelaRound(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Recycle_item(
                            name: 'paper',
                          ),
                          Recycle_item(
                            name: 'can',
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Recycle_item(
                            name: 'glass',
                          ),
                          Recycle_item(
                            name: 'pet',
                          ),
                        ],
                      ),
                    ],
                  ),
                ), /*
                const Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LineChartSample2(),
                  ),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: 100,
          width: 100,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 232, 231, 231),
            onPressed: _openBarcodeScanner,
            child: const Icon(
              Icons.qr_code_2_rounded,
              size: 70,
              color: Colors.black,
            ),
          ),
        ), 
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child:
                        Container() /*IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      size: 50,
                    ),
                  ),*/
                    ),
              ),
              SizedBox(
                height: 100,
                child: Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child:
                        Container() /*IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      size: 50,
                    ),
                  ),*/
                    ),
              ),
            ],
          ),
        ),*/
