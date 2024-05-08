import 'package:flutter/material.dart';

class MyExtendedCompose extends StatelessWidget {
  final Function()? onTap;
  final IconData buttonIcon;
  final String buttonText;

  const MyExtendedCompose({
    Key? key,
    required this.onTap,
    required this.buttonIcon,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 130,
      height: 50,
      child: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
        onPressed: onTap,
        icon: Icon(
          buttonIcon,
          color: Colors.white,
        ),
        label: Center(
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
