import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:vary_recycle/screen/update_profile_screen.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: const Color(0xFFffc859),
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.grey.shade800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipOval(
                      child: Image.network(
                        FirebaseAuth.instance.currentUser?.photoURL ?? "NaN",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          //border: Border.all(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.shade200),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                FirebaseAuth.instance.currentUser?.displayName ?? "NaN",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
              Text(FirebaseAuth.instance.currentUser?.email ?? "NaN"),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  onPressed: () => Get.to(() => const UpdateProfileScreen()),
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(
                  width: 150,
                  height: 150,
                  child: RiveAnimation.asset(
                      "assets/RiveAssets/2131-4192-coin.riv")),
              const SizedBox(height: 15),
              const Text(
                "Credits",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Text(
                "18,274,972",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
