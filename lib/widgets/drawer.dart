import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:vary_recycle/screen/User_page.dart';
import 'package:vary_recycle/screen/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vary_recycle/screen/home_screen.dart';

class drawer extends StatefulWidget {
  const drawer({super.key});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          accountName: FutureBuilder(
            future: ReturnValue('name'),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text("error");
              } else {
                return Text(
                  '${snapshot.data}',
                );
              }
            },
          ),
          accountEmail: FutureBuilder(
            future: ReturnEmail(),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text("error");
              } else {
                return Text(
                  '${snapshot.data}',
                );
              }
            },
          ),
          currentAccountPicture: FutureBuilder(
              future: ReturnImage(),
              builder: (context, snapshot) {
                return const CircleAvatar(
                  radius: 10.0,
                  backgroundColor: Colors.transparent,
                  // child: ClipOval(
                  //   child: Image.network(
                  //     FirebaseAuth.instance.currentUser?.photoURL ?? "NaN",
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                );
              }),
          otherAccountsPictures: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Transform.scale(
                scale: 2.5,
                child: Transform.translate(
                  offset: const Offset(1.5, 3),
                  child: const RiveAnimation.asset(
                    "assets/RiveAssets/4390-9001-gdsc-logo-animation.riv",
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        ListTile(
          title: const Text("Setting"),
          leading: const Icon(Icons.settings),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingPage()));
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
    );
  }
}
