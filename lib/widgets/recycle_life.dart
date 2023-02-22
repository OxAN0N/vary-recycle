import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vary_recycle/screen/home_screen.dart';

class RecycleLife extends StatefulWidget {
  const RecycleLife({super.key});

  @override
  State<RecycleLife> createState() => _RecycleLifeState();
}

class _RecycleLifeState extends State<RecycleLife> {
  Future<int> LifeCount() async {
    final instance = FirebaseFirestore.instance;
    final result = await instance.collection('user').doc('$myUid').get();
    var list = result.data();
    var count = list?['countPerDay'];
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LifeCount(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text("error");
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < snapshot.data!; i++)
                const Icon(
                  Icons.energy_savings_leaf,
                  color: Color.fromARGB(255, 107, 255, 112),
                  size: 35,
                ),
              for (int i = snapshot.data!; i < 5; i++)
                const Icon(
                  Icons.energy_savings_leaf_outlined,
                  color: Colors.grey,
                  size: 35,
                )
            ],
          );
        }
      },
    );
  }
}
