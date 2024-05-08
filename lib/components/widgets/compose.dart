import 'package:flutter/material.dart';

class MyCompose extends StatelessWidget {
  final Function()? onTap;
  final IconData buttonIcon;

  const MyCompose({
    Key? key,
    required this.onTap,
    required this.buttonIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 50,
      height: 50,
      child: FloatingActionButton.extended(
        backgroundColor: Color.fromRGBO(43, 52, 153, 1),
        onPressed: onTap,
        icon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            buttonIcon,
            color: Colors.white,
          ),
        ),
        label: SizedBox(),
      ),
    );
  }
}
