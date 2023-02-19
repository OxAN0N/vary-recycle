import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    Key? key,
    this.heightBetween,
    required this.rivAni,
    required this.subTitle,
    required this.title,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textAlign,
  }) : super(key: key);

  //Variables -- Declared in Constructor
  final double? heightBetween;
  final String title, subTitle;
  final dynamic rivAni;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        SizedBox(width: 400, height: 200, child: rivAni),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          subTitle,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: textAlign,
        ),
        // const SizedBox(
        //   height: 20,
        // ),
      ],
    );
  }
}
