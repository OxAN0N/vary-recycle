import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 400,
          height: 200,
          child: RiveAnimation.asset(
            "assets/RiveAssets/natural.div",
            fit: BoxFit.fill,
            alignment: Alignment.center,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          ("Welcome,"),
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(("Let's clean Recycle!"),
            style: Theme.of(context).textTheme.bodyText1),
        // const SizedBox(
        //   height: 20,
        // ),
      ],
    );
  }
}
