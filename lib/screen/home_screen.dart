import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive/rive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vary_recycle/widgets/recycle_life.dart';
import 'package:vary_recycle/widgets/recycle_item.dart';
import 'package:vary_recycle/widgets/drawer.dart';

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
        endDrawer: const drawer(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
