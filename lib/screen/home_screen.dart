import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vary_recycle/widgets/recycle_life.dart';
import 'package:vary_recycle/widgets/recycle_item.dart';
import 'package:vary_recycle/widgets/drawer.dart';

FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;
var myUid = user?.uid;

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
        'currentReq': Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().millisecond - 10000),
        'countPerDay': 0
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
          title: SizedBox(
              height: kToolbarHeight, child: Image.asset('assets/logo.png')),
          centerTitle: false,
          // centerTitle: false,

          iconTheme: const IconThemeData(
            size: 30,
            color: Color.fromARGB(255, 3, 206, 117),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        endDrawer: const drawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/HOME_page/background.jpg'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 80,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: FutureBuilder(
                    future: ReturnValue('name'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text("error");
                      } else {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 40, 0, 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${snapshot.data}',
                                  style: GoogleFonts.varelaRound(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "\"Reduce, Reuse, Recycle!\"",
                                  style: GoogleFonts.varelaRound(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Expanded(
                    flex: 2,
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Align(
                            child: Expanded(
                              child: RecycleLife(),
                            ),
                          ),
                          FutureBuilder(
                            future: ReturnValue('credit'),
                            builder: (context, snapshot) {
                              if (snapshot.hasData == false) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text("error");
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    right: 50,
                                  ),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    '+ ${snapshot.data}%',
                                    style: GoogleFonts.varelaRound(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromARGB(
                                          255, 3, 206, 117),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      FutureBuilder(
                        future: ReturnValue('credit'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData == false) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text("error");
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                right: 40,
                              ),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  '\$${snapshot.data}',
                                  style: GoogleFonts.varelaRound(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Click what you recylce",
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
                  flex: 7,
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
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
