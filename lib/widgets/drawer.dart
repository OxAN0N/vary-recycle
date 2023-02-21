import 'package:flutter/material.dart';
import 'package:vary_recycle/screen/User_page.dart';
import 'package:vary_recycle/screen/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class drawer extends StatefulWidget {
  const drawer({super.key});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  late dynamic userName =
      FirebaseAuth.instance.currentUser?.displayName ?? "NaN";
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
          accountName: Text(userName),
          accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? "NaN"),
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
